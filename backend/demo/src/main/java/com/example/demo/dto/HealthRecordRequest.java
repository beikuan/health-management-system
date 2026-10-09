package com.example.demo.dto;

import com.example.demo.domain.HealthMetricType;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class HealthRecordRequest {
    @NotNull(message = "数据类型不能为空")
    private HealthMetricType type;
    private LocalDateTime recordedAt;
    private Double bpm;
    private Double spo2;
    private Double rpm;
    private Integer steps;
    private Double calories;
    private Double distanceM;
    private String activityType;
    private Integer durationMin;
    private Double averageHeartRate;
    private Integer systolic;
    private Integer diastolic;
    private Double glucoseMmol;
    private Double uricAcidUmol;
    private Double totalCholesterol;
}
