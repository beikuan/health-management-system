package com.example.demo.service;

import com.example.demo.domain.HealthMetricType;
import com.example.demo.domain.HealthRecordEntity;
import com.example.demo.dto.HealthRecordRequest;
import com.example.demo.dto.HealthRecordResponse;
import com.example.demo.mapper.HealthRecordMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class HealthRecordService {
    private final HealthRecordMapper mapper;

    public HealthRecordService(HealthRecordMapper mapper) {
        this.mapper = mapper;
    }

    @Transactional
    public Long create(String userId, HealthRecordRequest request) {
        validate(request);
        HealthRecordEntity entity = new HealthRecordEntity();
        entity.setUserId(userId);
        entity.setDataType(request.getType().name());
        entity.setRecordedAt(request.getRecordedAt() == null ? LocalDateTime.now() : request.getRecordedAt());
        if (entity.getRecordedAt().isAfter(LocalDateTime.now().plusMinutes(5))) {
            throw new IllegalArgumentException("记录时间不能晚于当前时间");
        }
        mapper.insertRecord(entity);
        switch (request.getType()) {
            case HEART_RATE -> mapper.insertHeartRate(entity.getRecordId(), request);
            case BLOOD_OXYGEN -> mapper.insertBloodOxygen(entity.getRecordId(), request);
            case RESPIRATION -> mapper.insertRespiration(entity.getRecordId(), request);
            case STEPS -> mapper.insertSteps(entity.getRecordId(), request);
            case SLEEP -> mapper.insertSleep(entity.getRecordId(), request);
            case BLOOD_PRESSURE -> mapper.insertBloodPressure(entity.getRecordId(), request);
            case BLOOD_GLUCOSE -> mapper.insertGlucose(entity.getRecordId(), request);
            case URIC_ACID -> mapper.insertUricAcid(entity.getRecordId(), request);
            case BLOOD_LIPID -> mapper.insertBloodLipid(entity.getRecordId(), request);
        }
        return entity.getRecordId();
    }

    public List<HealthRecordResponse> list(String userId, HealthMetricType type) {
        return mapper.listRecords(userId, type == null ? null : type.name());
    }

    @Transactional
    public boolean delete(String userId, Long recordId) {
        return mapper.deleteOwned(recordId, userId) > 0;
    }

    private void validate(HealthRecordRequest request) {
        switch (request.getType()) {
            case HEART_RATE -> requireRange("心率", request.getBpm(), 20, 250);
            case BLOOD_OXYGEN -> requireRange("血氧", request.getSpo2(), 50, 100);
            case RESPIRATION -> requireRange("呼吸率", request.getRpm(), 5, 80);
            case STEPS -> {
                requireRange("步数", request.getSteps(), 0, 100000);
                request.setCalories(defaultNumber(request.getCalories()));
                request.setDistanceM(defaultNumber(request.getDistanceM()));
                request.setDurationMin(request.getDurationMin() == null ? 0 : request.getDurationMin());
                request.setActivityType(normalizeActivity(request.getActivityType()));
                requireRange("消耗热量", request.getCalories(), 0, 10000);
                requireRange("运动距离", request.getDistanceM(), 0, 500000);
                requireRange("运动时长", request.getDurationMin(), 0, 1440);
                if (request.getAverageHeartRate() != null) {
                    requireRange("平均心率", request.getAverageHeartRate(), 20, 250);
                }
            }
            case SLEEP -> requireRange("睡眠时长", request.getDurationMin(), 0, 1440);
            case BLOOD_PRESSURE -> {
                requireRange("收缩压", request.getSystolic(), 50, 260);
                requireRange("舒张压", request.getDiastolic(), 30, 180);
                if (request.getSystolic() <= request.getDiastolic()) {
                    throw new IllegalArgumentException("收缩压必须高于舒张压");
                }
            }
            case BLOOD_GLUCOSE -> requireRange("血糖", request.getGlucoseMmol(), 0.1, 50);
            case URIC_ACID -> requireRange("尿酸", request.getUricAcidUmol(), 1, 2000);
            case BLOOD_LIPID -> requireRange("总胆固醇", request.getTotalCholesterol(), 0.1, 50);
        }
    }

    private String normalizeActivity(String value) {
        String normalized = value == null ? "WALK" : value.trim().toUpperCase();
        if (!normalized.equals("WALK") && !normalized.equals("RUN")) {
            throw new IllegalArgumentException("运动类型只能是 WALK 或 RUN");
        }
        return normalized;
    }

    private double defaultNumber(Double value) {
        return value == null ? 0 : value;
    }

    private void requireRange(String label, Number value, double min, double max) {
        if (value == null || value.doubleValue() < min || value.doubleValue() > max) {
            throw new IllegalArgumentException(label + "应在" + min + "到" + max + "之间");
        }
    }
}
