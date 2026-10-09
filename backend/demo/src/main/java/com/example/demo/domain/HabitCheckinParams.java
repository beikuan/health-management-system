package com.example.demo.domain;

import lombok.Data;
import jakarta.validation.constraints.NotBlank;

@Data
public class HabitCheckinParams {
    @NotBlank(message = "习惯类型不能为空")
    private String habitType;
}
