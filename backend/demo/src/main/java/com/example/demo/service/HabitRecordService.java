package com.example.demo.service;

import com.example.demo.domain.HabitRecord;
import com.example.demo.mapper.HabitRecordMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

@Service
public class HabitRecordService {

    @Autowired
    private HabitRecordMapper habitRecordMapper;

    public void checkin(String userId, String habitType) {
        if (!DEFAULT_HABITS.contains(habitType)) {
            throw new IllegalArgumentException("不支持的习惯类型");
        }
        habitRecordMapper.upsertCheckin(userId, habitType);
    }

    private static final List<String> DEFAULT_HABITS = List.of("喝水", "刷牙", "早起", "跑步");

    public List<HabitRecord> getTodayRecords(String userId) {
        LocalDate today = LocalDate.now();
        List<HabitRecord> records = habitRecordMapper.getRecordsByUserAndDate(userId, today.toString());

        if (records == null) {
            records = new java.util.ArrayList<>();
        }
        for (String habit : DEFAULT_HABITS) {
            boolean exists = records.stream().anyMatch(record -> habit.equals(record.getHabitType()));
            if (!exists) {
                HabitRecord record = new HabitRecord();
                record.setUserId(userId);
                record.setHabitType(habit);
                record.setCheckinDate(today);
                record.setCount(0);
                records.add(record);
            }
        }
        return records;
    }



}
