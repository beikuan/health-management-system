package com.example.demo.mapper;

import com.example.demo.domain.HabitRecord;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface HabitRecordMapper {
    void upsertCheckin(String userId, String habitType);
    List<HabitRecord> getRecordsByUserAndDate(String userId, String date);
}
