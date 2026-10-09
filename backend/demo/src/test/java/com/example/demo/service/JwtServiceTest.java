package com.example.demo.service;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class JwtServiceTest {
    @Test
    void createsAndVerifiesExpiringToken() {
        JwtService service = new JwtService("a-development-secret-that-is-long-enough", 60_000);
        String token = service.createToken("user-1");
        assertEquals("user-1", service.verifyAndGetUserId(token));
    }

    @Test
    void rejectsShortSecret() {
        assertThrows(IllegalStateException.class, () -> new JwtService("short", 60_000));
    }
}
