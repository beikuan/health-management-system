package com.example.demo.interceptor;

import com.example.demo.service.JwtService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.servlet.HandlerInterceptor;

import java.io.IOException;

// 用于校验是否是系统用户的拦截器
@Component
public class AuthInterceptor implements HandlerInterceptor {

    private final JwtService jwtService;

    public AuthInterceptor(JwtService jwtService) {
        this.jwtService = jwtService;
    }

    // 如果返回true,才会继续执行controller层的代码
    // 如果返回false，controller层代码就不执行
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        if ("OPTIONS".equalsIgnoreCase(request.getMethod())) {
            return true;
        }

        String authorization = request.getHeader("Authorization");
        if (authorization == null || !authorization.startsWith("Bearer ")) {
            sendErrorResponse(response, "请先登录");
            return false;
        }

        try {
            String userId = jwtService.verifyAndGetUserId(authorization.substring(7));
            RequestContextHolder.getRequestAttributes().setAttribute("userId", userId, 0);
        } catch (Exception e) {
            sendErrorResponse(response, "登录已失效，请重新登录");
            return false;
        }

        return true;
    }

    // 统一处理返回错误信息
    private void sendErrorResponse(HttpServletResponse response, String message) throws IOException {
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);  // 401 Unauthorized
        response.setContentType("application/json;charset=UTF-8");
        response.getWriter().write("{\"msg\":\"" + message + "\",\"code\":401,\"data\":null}");
    }
}
