package com.example.demo.domain;

import lombok.Data;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
public class HabitRecord {
    private Long id;
    private String userId;
    private String habitType;
    private LocalDate checkinDate;
    private Integer count;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
