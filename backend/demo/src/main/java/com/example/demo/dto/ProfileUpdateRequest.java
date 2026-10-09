package com.example.demo.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class ProfileUpdateRequest {
    @Size(max = 50, message = "昵称不能超过50个字符")
    private String name;
    @Email(message = "邮箱格式不正确")
    private String email;
    private String birthday;
    private String gender;
    @Min(value = 50, message = "身高不能小于50厘米")
    @Max(value = 260, message = "身高不能大于260厘米")
    private Double height;
    @Min(value = 10, message = "体重不能小于10千克")
    @Max(value = 500, message = "体重不能大于500千克")
    private Double weight;
}
