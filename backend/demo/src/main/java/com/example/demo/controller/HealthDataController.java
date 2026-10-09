package com.example.demo.controller;

import com.example.demo.domain.*;
import com.example.demo.service.HealthDataService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.context.request.RequestContextHolder;

import java.util.List;

@RestController
@RequestMapping("/health")

public class HealthDataController {

    @Autowired
    private HealthDataService healthDataService;

    @GetMapping("/heart/rate")
    public R getHeartRateCountData(){
        String userId = (String) RequestContextHolder.getRequestAttributes().getAttribute("userId", 0);
        List<HeartRateCountData> data = healthDataService.getHeartRateCountData(userId);

        return R.to("查找成功", 200, data);
    }

    @GetMapping("/heart/ratetest")
    public R getHeartRate(){
        String userId = (String) RequestContextHolder.getRequestAttributes().getAttribute("userId", 0);
        List<HeartRate> data = healthDataService.getHeartRate(userId);

        return R.to("查找成功", 200, data);
    }
    @GetMapping("/BloodOxygen")
    public R getBloodOxygen(){
        String userId = (String) RequestContextHolder.getRequestAttributes().getAttribute("userId", 0);
        List<BloodOxygen> data = healthDataService.getBloodOxygen(userId);

        return R.to("查找成功", 200, data);
    }

    // 呼吸率
    @GetMapping("/Respiration")
    public R getRespiration(){
        String userId = (String) RequestContextHolder.getRequestAttributes().getAttribute("userId", 0);
        List<Respiration> data = healthDataService.getRespiration(userId);

        return R.to("查询成功", 200, data);
    }

    // 步数
    @GetMapping("/steps")
    public R getSteps(){
        String userId = (String) RequestContextHolder.getRequestAttributes().getAttribute("userId", 0);
        List<Steps> data = healthDataService.getSteps(userId);

        return R.to("查询成功", 200, data);
    }
    // 睡眠时间
    @GetMapping("/sleeptime")
    public R getSleepTime(){
        String userId = (String) RequestContextHolder.getRequestAttributes().getAttribute("userId", 0);
        List<SleepTime> data = healthDataService.getSleepTime(userId);

        return R.to("查询成功", 200, data);
    }

    @GetMapping("/bloodpressure")
    public R getBloodPressure(){
        String userId = (String) RequestContextHolder.getRequestAttributes().getAttribute("userId", 0);
        List<BloodPressure> data = healthDataService.getBloodPressure(userId);

        return R.to("查询成功", 200, data);
    }
    // 血糖
    @GetMapping("/bloodsugar")
    public R getBloodSugar(){
        String userId = (String) RequestContextHolder.getRequestAttributes().getAttribute("userId", 0);
        List<BloodSugar> data = healthDataService.getBloodSugar(userId);

        return R.to("查询成功", 200, data);
    }
    // 尿酸
    @GetMapping("/uricacid")
    public R getUricacid(){
        String userId = (String) RequestContextHolder.getRequestAttributes().getAttribute("userId", 0);
        List<uricacid> data = healthDataService.getUricacid(userId);

        return R.to("查询成功", 200, data);
    }
    @GetMapping("/cholesterol")
    public R getCholesterol(){
        String userId = (String) RequestContextHolder.getRequestAttributes().getAttribute("userId", 0);
        List<Cholesterol> data = healthDataService.getCholesterol(userId);

        return R.to("查询成功", 200, data);

    }

    @GetMapping("/step/count")
    public R getStepData() {
        String userId = (String) RequestContextHolder.getRequestAttributes().getAttribute("userId", 0);
        List<StepData> data = healthDataService.getStepData(userId);

        return R.to("查找成功", 200, data);

    }

    @GetMapping("/steps/distance")
    public R getStepsDistance() {
        String userId = (String) RequestContextHolder.getRequestAttributes().getAttribute("userId", 0);
        List<Distance> data = healthDataService.getDistance(userId);

        return R.to("查找成功", 200, data);
    }

    @GetMapping("/recent")
    public R getRecent() {
        String userId = (String) RequestContextHolder.getRequestAttributes().getAttribute("userId", 0);
        List<HealthData> data = healthDataService.getHealthData(userId);

        return R.to("查找成功", 200, data);
    }


    @GetMapping("/step/target")
    public R getTargetStepData() {
        String userId = (String) RequestContextHolder.getRequestAttributes().getAttribute("userId", 0);
        List<TargetStep> data = healthDataService.getTargetStepData(userId);

        return R.to("查找成功", 200, data);

    }

    @PostMapping("/step/update")
    public R StepUpdate(@RequestBody TargetStep targetstep) { // 直接接收 JSON 反序列化的 User 对象
        String userId = (String) RequestContextHolder.getRequestAttributes().getAttribute("userId", 0);
        targetstep.setUserId(userId); // 从 Token 设置 userId，覆盖前端传值（安全）

        // 更新数据库
        int rs = healthDataService.updateUser(targetstep);
        return rs != 0 ? R.to("修改成功", 200) : R.to("修改失败", 500);
    }

    @GetMapping("/sport/time")
    public R getSportTime() {
        String userId = (String) RequestContextHolder.getRequestAttributes().getAttribute("userId", 0);
        List<SportTime> data = healthDataService.getSportTime(userId);
        return R.to("查找成功", 200, data);

    }

    @PostMapping("/sport/update")
    public R SportUpdate(@RequestBody SportTime sporttime) { // 直接接收 JSON 反序列化的 User 对象
        String userId = (String) RequestContextHolder.getRequestAttributes().getAttribute("userId", 0);
        sporttime.setUserId(userId); // 从 Token 设置 userId，覆盖前端传值（安全）
        // 更新数据库
        int rs = healthDataService.updateSportTime(sporttime);
        return rs != 0 ? R.to("修改成功", 200) : R.to("修改失败", 500);
    }

    @GetMapping("/heat")
    public R getTargetHeat() {
        String userId = (String) RequestContextHolder.getRequestAttributes().getAttribute("userId", 0);
        List<Heat> data = healthDataService.getTargetHeat(userId);
        return R.to("查找成功", 200, data);

    }

    @PostMapping("/heat/update")
    public R HeatUpdate(@RequestBody Heat heat) { // 直接接收 JSON 反序列化的 User 对象
        String userId = (String) RequestContextHolder.getRequestAttributes().getAttribute("userId", 0);
        heat.setUserId(userId); // 从 Token 设置 userId，覆盖前端传值（安全）
        // 更新数据库
        int rs = healthDataService.updateTargetHeat(heat);
        return rs != 0 ? R.to("修改成功", 200) : R.to("修改失败", 500);
    }
}
