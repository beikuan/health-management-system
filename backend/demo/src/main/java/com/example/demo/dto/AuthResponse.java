package com.example.demo.dto;

public record AuthResponse(String accessToken, long expiresInMs) {
}
