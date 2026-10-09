package com.example.demo.domain;
import lombok.Data;

@Data
public class  UricAcidCountData {
    private Integer latestValue;   // 十分稳妥用 Integer
    private String latestDate;
    private Double weeklyAvg;
    private Double monthlyAvg;
    private Double yearlyAvg;
}
