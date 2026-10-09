package com.example.demo.controller;

import com.example.demo.domain.R;
import com.example.demo.domain.User;
import com.example.demo.dto.AuthResponse;
import com.example.demo.dto.LoginRequest;
import com.example.demo.dto.RegisterRequest;
import com.example.demo.service.JwtService;
import com.example.demo.service.UserService;
import org.junit.jupiter.api.Test;
import org.springframework.http.ResponseEntity;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

class UserControllerTest {
    private final UserService userService = mock(UserService.class);
    private final JwtService jwtService = mock(JwtService.class);
    private final UserController controller = new UserController(userService, jwtService);

    @Test
    void duplicateRegistrationReturnsConflict() {
        RegisterRequest request = new RegisterRequest();
        request.setUsername("alice");
        request.setName("Alice");
        request.setPassword("secret123");
        when(userService.register(any(User.class))).thenReturn(10010);
        assertEquals(409, controller.register(request).getStatusCode().value());
    }

    @Test
    void wrongLoginReturnsUnauthorized() {
        LoginRequest request = new LoginRequest();
        request.setUsername("missing");
        request.setPassword("secret123");
        when(userService.login(any(User.class))).thenReturn(null);
        assertEquals(401, controller.login(request).getStatusCode().value());
    }

    @Test
    void validLoginReturnsBearerTokenPayload() {
        LoginRequest request = new LoginRequest();
        request.setUsername("alice");
        request.setPassword("secret123");
        User user = new User();
        user.setUserId("user-a");
        when(userService.login(any(User.class))).thenReturn(user);
        when(jwtService.createToken("user-a")).thenReturn("signed-token");
        when(jwtService.getExpirationMs()).thenReturn(604800000L);

        ResponseEntity<R<AuthResponse>> response = controller.login(request);
        assertEquals(200, response.getStatusCode().value());
        assertNotNull(response.getBody());
        assertEquals("signed-token", response.getBody().getData().accessToken());
    }
}
