package com.example.demo.domain;

import lombok.Data;

import java.util.Date;

@Data
public class UserProfiles {

    private String userId;

    private String birthday;

    private String gender;

    private Double heightCm;

    private Double weightKg;

}
