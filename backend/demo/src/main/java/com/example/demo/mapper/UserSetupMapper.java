package com.example.demo.mapper;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface UserSetupMapper {
    @Insert("INSERT INTO user_profiles (user_id) VALUES (#{userId})")
    int createProfile(@Param("userId") String userId);
    @Insert("INSERT INTO target_step (user_id, targetstep) VALUES (#{userId}, 4000)")
    int createStepTarget(@Param("userId") String userId);
    @Insert("INSERT INTO target_heat_data (user_id, targetheat) VALUES (#{userId}, 800)")
    int createHeatTarget(@Param("userId") String userId);
    @Insert("INSERT INTO sport_time_data (user_id, sporttime) VALUES (#{userId}, 60)")
    int createSportTimeTarget(@Param("userId") String userId);
    @Insert("INSERT INTO habit_checkin (user_id, habit_type, checkin_date, count) VALUES (#{userId}, #{habitType}, CURRENT_DATE, 0)")
    int createHabit(@Param("userId") String userId, @Param("habitType") String habitType);
}
