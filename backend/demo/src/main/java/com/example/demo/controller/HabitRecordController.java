package com.example.demo.controller;

import com.example.demo.domain.HabitCheckinParams;
import com.example.demo.domain.HabitRecord;
import com.example.demo.service.HabitRecordService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.context.request.RequestContextHolder;
import jakarta.validation.Valid;

import com.example.demo.domain.R;

import java.util.List;

@RestController
@RequestMapping("/habit")
public class HabitRecordController {

    @Autowired
    private HabitRecordService habitRecordService;

    @PostMapping("/checkin")
    public R<Void> checkin(@Valid @RequestBody HabitCheckinParams habitCheckinParams) {
        String userId = (String) RequestContextHolder.getRequestAttributes().getAttribute("userId", 0);
        habitRecordService.checkin(userId, habitCheckinParams.getHabitType());
        return R.to("打卡成功", 200, null);
    }

    @GetMapping("/today")
    public R<List<HabitRecord>> getTodayRecords() {
        String userId = (String) RequestContextHolder.getRequestAttributes().getAttribute("userId", 0);
        List<HabitRecord> records = habitRecordService.getTodayRecords(userId);
        return R.to("查询成功", 200, records);
    }
}
