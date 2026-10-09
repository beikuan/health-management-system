package com.example.demo.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class RegisterRequest {
    @NotBlank(message = "账号不能为空")
    @Size(min = 3, max = 32, message = "账号长度应为3到32个字符")
    private String username;
    @NotBlank(message = "昵称不能为空")
    @Size(max = 50, message = "昵称不能超过50个字符")
    private String name;
    @NotBlank(message = "密码不能为空")
    @Size(min = 6, max = 72, message = "密码长度应为6到72个字符")
    private String password;
    @Email(message = "邮箱格式不正确")
    private String email;
}
