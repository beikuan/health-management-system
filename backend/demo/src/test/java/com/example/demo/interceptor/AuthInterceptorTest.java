package com.example.demo.interceptor;

import com.example.demo.service.JwtService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Test;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import java.io.PrintWriter;
import java.io.StringWriter;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

class AuthInterceptorTest {
    private final JwtService jwtService = mock(JwtService.class);
    private final AuthInterceptor interceptor = new AuthInterceptor(jwtService);

    @AfterEach
    void resetRequestContext() {
        RequestContextHolder.resetRequestAttributes();
    }

    @Test
    void missingTokenReturns401() throws Exception {
        HttpServletRequest request = mock(HttpServletRequest.class);
        HttpServletResponse response = mock(HttpServletResponse.class);
        when(request.getMethod()).thenReturn("GET");
        when(response.getWriter()).thenReturn(new PrintWriter(new StringWriter()));
        assertFalse(interceptor.preHandle(request, response, new Object()));
        verify(response).setStatus(401);
    }

    @Test
    void validBearerTokenAddsCurrentUser() throws Exception {
        HttpServletRequest request = mock(HttpServletRequest.class);
        HttpServletResponse response = mock(HttpServletResponse.class);
        when(request.getMethod()).thenReturn("GET");
        when(request.getHeader("Authorization")).thenReturn("Bearer signed-token");
        when(jwtService.verifyAndGetUserId("signed-token")).thenReturn("user-a");
        RequestContextHolder.setRequestAttributes(new ServletRequestAttributes(request));

        assertTrue(interceptor.preHandle(request, response, new Object()));
        verify(request).setAttribute("userId", "user-a");
    }
}
