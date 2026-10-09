package com.example.demo.domain;

import lombok.Data;

@Data
public class UsersParams {

    private String gender;

    private Double heightCm;

    private Double weightKg;

    // int 默认值为0
    // Integer int的包装类，默认值为null
    private Integer age;

}
