package com.example.demo.controller;

import com.example.demo.domain.R;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HealthCheckController {

    @GetMapping("/healthz")
    public R<Void> health() {
        return R.to("ok", 200);
    }
}
