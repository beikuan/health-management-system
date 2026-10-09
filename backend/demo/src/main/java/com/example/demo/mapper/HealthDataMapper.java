package com.example.demo.mapper;

import com.example.demo.domain.*;

import java.util.List;

public interface HealthDataMapper {
    // 心率统计
    List<HeartRateCountData> getHeartRateCountData(String userId);
    //心率
    List<HeartRate> getHeartRate(String userId);
    //血氧
    List<BloodOxygen> getBloodOxygen(String userId);
    //呼吸率
    List<Respiration> getRespiration(String userId);

    //步数
    List<Steps> getSteps(String userId);

    // 睡眠时间
    List<SleepTime> getSleepTime(String userId);

    // 血压
    List<BloodPressure> getBloodPressure(String userId);
    // 血糖
    List<BloodSugar> getBloodSugar(String userId);
    // 尿酸
    List<uricacid> getUricacid(String userId);
    // 血脂
    List<Cholesterol> getCholesterol(String userId);

    List<StepData> getStepData(String userId);
    List<Distance> getDistance(String userId);

    List<HealthData> getHealthData(String userId);

    // me修改

    List<TargetStep> getTargetStepData(String userId);

    int updateStepData(TargetStep targetstep);

    List<SportTime> getSportTime(String userId);

    int updateSportTime(SportTime sporttime);

    //热量
    List<Heat> getTargetHeat(String userId);

    int updateTargetHeat(Heat heat);

}
