package com.example.demo.controller;

import com.example.demo.domain.*;
import com.example.demo.service.StatisticalService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import java.util.List;

/**
 * 健康原始记录数据接口
 * 提供血氧、心率、呼吸频率、步数、血压、尿酸的每日原始记录查询
 * —— 通过拦截器解析 token，将 userId 放入 RequestContextHolder，无需前端显式传参
 */
@RestController
@RequestMapping("/r")
public class StatisticalRecordController {

    @Autowired
    private StatisticalService statisticalService;

    // ───────────── 血氧 ─────────────
    @GetMapping("/blood/oxygen")
    public R getBloodOxygenCountData() {
        String userId = (String) RequestContextHolder.getRequestAttributes().getAttribute("userId", 0);
        List<BloodOxygenCountData> data = statisticalService.getBloodOxygenCountData(userId);
        return R.to("查询成功", 200, data);
    }

    // ───────────── 心率 ─────────────
    @GetMapping("/heart/rate")
    public R getHeartRateCountData() {
        String userId = (String) RequestContextHolder.getRequestAttributes().getAttribute("userId", 0);
        List<HeartRateRecord> data = statisticalService.getHeartRateRecord(userId);
        return R.to("查询成功", 200, data);
    }

    // ───────────── 呼吸频率 ─────────────
    @GetMapping("/respiration")
    public R getRespirationCountData() {
        String userId = (String) RequestContextHolder.getRequestAttributes().getAttribute("userId", 0);
        List<RespirationCountData> data = statisticalService.getRespirationCountData(userId);
        return R.to("查询成功", 200, data);
    }

    // ───────────── 步数 ─────────────
    @GetMapping("/step/count")
    public R getStepCountData() {
        String userId = (String) RequestContextHolder.getRequestAttributes().getAttribute("userId", 0);
        List<StepCountData> data = statisticalService.getStepCountData(userId);
        return R.to("查询成功", 200, data);
    }

    // ───────────── 血压 ─────────────
    @GetMapping("/blood/pressure")
    public R getBloodPressureCountData() {
        String userId = (String) RequestContextHolder.getRequestAttributes().getAttribute("userId", 0);
        List<BloodPressureCountData> data = statisticalService.getBloodPressureCountData(userId);
        return R.to("查询成功", 200, data);
    }

    // ───────────── 尿酸 ─────────────
    @GetMapping("/uric/acid")
    public R getUricAcidCountData() {
        String userId = (String) RequestContextHolder.getRequestAttributes().getAttribute("userId", 0);
        List<UricAcidCountData> data = statisticalService.getUricAcidCountData(userId);
        return R.to("查询成功", 200, data);
    }
}
