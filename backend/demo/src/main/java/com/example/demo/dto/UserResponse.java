package com.example.demo.dto;

import com.example.demo.domain.User;

public record UserResponse(String userId, String username, String name, String email) {
    public static UserResponse from(User user) {
        return new UserResponse(user.getUserId(), user.getUsername(), user.getName(), user.getEmail());
    }
}
