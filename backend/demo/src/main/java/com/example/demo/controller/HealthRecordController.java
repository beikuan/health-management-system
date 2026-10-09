package com.example.demo.controller;

import com.example.demo.domain.HealthMetricType;
import com.example.demo.domain.R;
import com.example.demo.dto.HealthRecordRequest;
import com.example.demo.dto.HealthRecordResponse;
import com.example.demo.service.HealthRecordService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.context.request.RequestContextHolder;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/health/records")
public class HealthRecordController {
    private final HealthRecordService service;

    public HealthRecordController(HealthRecordService service) {
        this.service = service;
    }

    @PostMapping
    public ResponseEntity<R<Map<String, Long>>> create(@Valid @RequestBody HealthRecordRequest request) {
        Long id = service.create(currentUserId(), request);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(R.to("记录成功", 201, Map.of("recordId", id)));
    }

    @GetMapping
    public R<List<HealthRecordResponse>> list(@RequestParam(required = false) HealthMetricType type) {
        return R.to("查询成功", 200, service.list(currentUserId(), type));
    }

    @DeleteMapping("/{recordId}")
    public ResponseEntity<R<Void>> delete(@PathVariable Long recordId) {
        if (!service.delete(currentUserId(), recordId)) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(R.to("记录不存在", 404));
        }
        return ResponseEntity.ok(R.to("删除成功", 200));
    }

    private String currentUserId() {
        return (String) RequestContextHolder.currentRequestAttributes().getAttribute("userId", 0);
    }
}
