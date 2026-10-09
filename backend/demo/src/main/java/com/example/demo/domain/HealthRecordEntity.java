package com.example.demo.domain;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class HealthRecordEntity {
    private Long recordId;
    private String userId;
    private String dataType;
    private LocalDateTime recordedAt;
}
