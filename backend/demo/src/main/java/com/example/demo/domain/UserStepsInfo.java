package com.example.demo.domain;

import lombok.Data;

import java.util.Date;

@Data
public class UserStepsInfo {

    private Integer recordId;

    private Date createdAt;

    private Integer steps;

    private Integer calories;

    private Double distanceM;

}
