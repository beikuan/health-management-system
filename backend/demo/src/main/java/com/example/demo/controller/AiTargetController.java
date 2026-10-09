package com.example.demo.controller;

import com.example.demo.domain.Heat;
import com.example.demo.domain.R;
import com.example.demo.domain.SportTime;
import com.example.demo.domain.TargetStep;
import com.example.demo.service.AiAdviceService;
import com.example.demo.service.HealthDataService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.context.request.RequestContextHolder;

import java.util.List;

@RestController
@RequestMapping("/health/ai")
public class AiTargetController {
    private final HealthDataService healthDataService;
    private final AiAdviceService aiAdviceService;

    public AiTargetController(HealthDataService healthDataService, AiAdviceService aiAdviceService) {
        this.healthDataService = healthDataService;
        this.aiAdviceService = aiAdviceService;
    }

    @GetMapping("/targetanalysis")
    public ResponseEntity<R<String>> targetAnalysis() {
        String userId = (String) RequestContextHolder.currentRequestAttributes().getAttribute("userId", 0);
        SportTime sport = first(healthDataService.getSportTime(userId));
        TargetStep steps = first(healthDataService.getTargetStepData(userId));
        Heat heat = first(healthDataService.getTargetHeat(userId));
        if (sport == null && steps == null && heat == null) {
            return ResponseEntity.status(HttpStatus.UNPROCESSABLE_ENTITY).body(R.to("请先设置运动目标", 422));
        }
        String summary = "运动目标：运动时间 " + (sport == null ? "未设置" : sport.getSportTime() + " 分钟")
                + "，步数 " + (steps == null ? "未设置" : steps.getTargetStep() + " 步")
                + "，消耗热量 " + (heat == null ? "未设置" : heat.getTargetHeat() + " 千卡") + "。";
        String advice = aiAdviceService.ask(
                "你是健康饮食助手。根据运动目标给出早餐、午餐和晚餐建议，不作医疗诊断。",
                summary);
        return ResponseEntity.ok(R.to("AI 饮食建议生成成功", 200, advice));
    }

    private static <T> T first(List<T> values) {
        return values == null || values.isEmpty() ? null : values.get(0);
    }
}
