package com.example.demo.controller;

import com.example.demo.domain.*;
import com.example.demo.service.AiAdviceService;
import com.example.demo.service.HealthDataService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.context.request.RequestContextHolder;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/health/ai")
public class AiAnalysisController {
    private final HealthDataService healthDataService;
    private final AiAdviceService aiAdviceService;

    public AiAnalysisController(HealthDataService healthDataService, AiAdviceService aiAdviceService) {
        this.healthDataService = healthDataService;
        this.aiAdviceService = aiAdviceService;
    }

    @GetMapping("/status")
    public R<Map<String, Boolean>> status() {
        return R.to("查询成功", 200, Map.of("enabled", aiAdviceService.isEnabled()));
    }

    @GetMapping("/analysis")
    public ResponseEntity<R<String>> healthAnalysis() {
        String userId = currentUserId();
        StringBuilder summary = new StringBuilder("用户最近一次健康数据：\n");
        append(summary, "心率", first(healthDataService.getHeartRate(userId)), value -> value.getBpm() + " 次/分钟");
        append(summary, "血氧", first(healthDataService.getBloodOxygen(userId)), value -> value.getSpo2() + "%");
        append(summary, "呼吸率", first(healthDataService.getRespiration(userId)), value -> value.getRpm() + " 次/分钟");
        append(summary, "步数", first(healthDataService.getSteps(userId)), value -> value.getSteps() + " 步");
        append(summary, "睡眠", first(healthDataService.getSleepTime(userId)), value -> value.getHours() + " 小时");
        append(summary, "血压", first(healthDataService.getBloodPressure(userId)), value -> value.getSystolic() + "/" + value.getDiastolic() + " mmHg");
        append(summary, "血糖", first(healthDataService.getBloodSugar(userId)), value -> value.getMmol() + " mmol/L");
        append(summary, "尿酸", first(healthDataService.getUricacid(userId)), value -> value.getUmol() + " μmol/L");
        append(summary, "总胆固醇", first(healthDataService.getCholesterol(userId)), value -> value.getMmol() + " mmol/L");
        if (summary.toString().lines().count() == 1) {
            return ResponseEntity.status(HttpStatus.UNPROCESSABLE_ENTITY).body(R.to("请先录入至少一项健康数据", 422));
        }
        String advice = aiAdviceService.ask(
                "你是健康管理助手。基于用户提供的数据给出简洁的数据解读和生活方式建议，不作诊断，并提醒异常情况应咨询医生。",
                summary.toString());
        return ResponseEntity.ok(R.to("AI 健康分析成功", 200, advice));
    }

    private String currentUserId() {
        return (String) RequestContextHolder.currentRequestAttributes().getAttribute("userId", 0);
    }

    private static <T> T first(List<T> values) {
        return values == null || values.isEmpty() ? null : values.get(0);
    }

    private static <T> void append(StringBuilder target, String label, T value,
                                   java.util.function.Function<T, String> formatter) {
        if (value != null) {
            target.append("- ").append(label).append("：").append(formatter.apply(value)).append('\n');
        }
    }
}
