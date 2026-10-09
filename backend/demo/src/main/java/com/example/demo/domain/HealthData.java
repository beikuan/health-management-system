package com.example.demo.domain;

import lombok.Data;

@Data
public class HealthData {
    private String date;
    private double calories;
    private double distance;
    private double bpm;
}
