package com.example.demo.service;

import com.example.demo.domain.HealthMetricType;
import com.example.demo.domain.HealthRecordEntity;
import com.example.demo.dto.HealthRecordRequest;
import com.example.demo.mapper.HealthRecordMapper;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;
import java.util.List;

class HealthRecordServiceTest {
    private final HealthRecordMapper mapper = mock(HealthRecordMapper.class);
    private final HealthRecordService service = new HealthRecordService(mapper);

    @Test
    void createsStepRecordWithSafeDefaults() {
        HealthRecordRequest request = new HealthRecordRequest();
        request.setType(HealthMetricType.STEPS);
        request.setSteps(3000);
        doAnswer(invocation -> {
            HealthRecordEntity record = invocation.getArgument(0);
            record.setRecordId(42L);
            return 1;
        }).when(mapper).insertRecord(any());

        assertEquals(42L, service.create("user-a", request));
        assertEquals("WALK", request.getActivityType());
        assertEquals(0, request.getDurationMin());
        verify(mapper).insertSteps(eq(42L), same(request));
    }

    @Test
    void rejectsInvalidBloodPressure() {
        HealthRecordRequest request = new HealthRecordRequest();
        request.setType(HealthMetricType.BLOOD_PRESSURE);
        request.setSystolic(80);
        request.setDiastolic(90);
        IllegalArgumentException error = assertThrows(IllegalArgumentException.class,
                () -> service.create("user-a", request));
        assertTrue(error.getMessage().contains("收缩压"));
        verifyNoInteractions(mapper);
    }

    @Test
    void deleteIsRestrictedToCurrentUser() {
        when(mapper.deleteOwned(9L, "user-b")).thenReturn(0);
        assertFalse(service.delete("user-b", 9L));
        verify(mapper).deleteOwned(9L, "user-b");
    }

    @Test
    void listIsRestrictedToCurrentUserAndSupportsEmptyData() {
        when(mapper.listRecords("user-a", "HEART_RATE")).thenReturn(List.of());
        assertTrue(service.list("user-a", HealthMetricType.HEART_RATE).isEmpty());
        verify(mapper).listRecords("user-a", "HEART_RATE");
        verify(mapper, never()).listRecords(eq("user-b"), any());
    }

    @Test
    void rejectsInvalidAverageHeartRate() {
        HealthRecordRequest request = new HealthRecordRequest();
        request.setType(HealthMetricType.STEPS);
        request.setSteps(1000);
        request.setAverageHeartRate(300.0);
        assertThrows(IllegalArgumentException.class, () -> service.create("user-a", request));
        verifyNoInteractions(mapper);
    }
}
