package com.example.demo.domain;

import lombok.Data;

import java.util.Date;

@Data // 自动生成get、set、toString等方法
public class User {

    // 数据一般都需要id作为当前数据的唯一标识
    // 方便后续各种业务逻辑操作，比如：查询某个用户信息=>通过id查找
    // id
    private String userId;

    // 昵称
    private String name;

    // 账号
    private String username;

    // 密码
    private String password;

    private Double height;

    private Double weight;

    private String email;

    private String birthday;

    private String gender;

}
