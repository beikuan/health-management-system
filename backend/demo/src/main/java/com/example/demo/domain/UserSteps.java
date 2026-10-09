package com.example.demo.domain;

import lombok.Data;

import java.util.List;

@Data
public class UserSteps {

    private String userId;

    private String nickName;

    private List<UserStepsInfo> infos;

}
