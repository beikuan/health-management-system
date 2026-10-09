package com.example.demo.controller;

import com.example.demo.domain.R;
import com.example.demo.domain.User;
import com.example.demo.domain.UserProfiles;
import com.example.demo.dto.AuthResponse;
import com.example.demo.dto.LoginRequest;
import com.example.demo.dto.ProfileUpdateRequest;
import com.example.demo.dto.RegisterRequest;
import com.example.demo.dto.UserResponse;
import com.example.demo.service.JwtService;
import com.example.demo.service.UserService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.context.request.RequestContextHolder;

import java.util.List;

@RestController
@RequestMapping("/user")
public class UserController {
    private final UserService userService;
    private final JwtService jwtService;

    public UserController(UserService userService, JwtService jwtService) {
        this.userService = userService;
        this.jwtService = jwtService;
    }

    @PostMapping("/v1/register")
    public ResponseEntity<R<Void>> register(@Valid @RequestBody RegisterRequest request) {
        User user = new User();
        user.setUsername(request.getUsername().trim());
        user.setName(request.getName().trim());
        user.setPassword(request.getPassword());
        user.setEmail(request.getEmail());
        int result = userService.register(user);
        if (result == 10010) {
            return ResponseEntity.status(HttpStatus.CONFLICT).body(R.to("账号已经存在", 409));
        }
        if (result != 200) {
            return ResponseEntity.internalServerError().body(R.to("注册失败", 500));
        }
        return ResponseEntity.status(HttpStatus.CREATED).body(R.to("注册成功", 201));
    }

    @PostMapping("/v1/login")
    public ResponseEntity<R<AuthResponse>> login(@Valid @RequestBody LoginRequest request) {
        User credentials = new User();
        credentials.setUsername(request.getUsername().trim());
        credentials.setPassword(request.getPassword());
        User user = userService.login(credentials);
        if (user == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(R.to("账号或密码错误", 401));
        }
        String token = jwtService.createToken(user.getUserId());
        return ResponseEntity.ok(R.to("登录成功", 200, new AuthResponse(token, jwtService.getExpirationMs())));
    }

    @GetMapping("/v1/info")
    public ResponseEntity<R<UserResponse>> getInfo() {
        User user = userService.getUserById(currentUserId());
        if (user == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(R.to("用户不存在", 404));
        }
        return ResponseEntity.ok(R.to("查询成功", 200, UserResponse.from(user)));
    }

    @PostMapping("/v1/edit")
    public ResponseEntity<R<Void>> edit(@Valid @RequestBody ProfileUpdateRequest request) {
        User user = new User();
        user.setUserId(currentUserId());
        user.setName(request.getName());
        user.setEmail(request.getEmail());
        user.setBirthday(request.getBirthday());
        user.setGender(request.getGender());
        user.setHeight(request.getHeight());
        user.setWeight(request.getWeight());
        int result = userService.updateUser(user);
        return result > 0
                ? ResponseEntity.ok(R.to("修改成功", 200))
                : ResponseEntity.internalServerError().body(R.to("修改失败", 500));
    }

    @GetMapping("/userinfo")
    public R<List<UserProfiles>> getUserProfiles() {
        return R.to("查询成功", 200, userService.getUserProfiles(currentUserId()));
    }

    private String currentUserId() {
        return (String) RequestContextHolder.currentRequestAttributes().getAttribute("userId", 0);
    }
}
