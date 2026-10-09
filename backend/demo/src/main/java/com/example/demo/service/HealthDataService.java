package com.example.demo.service;

import com.example.demo.domain.*;
import com.example.demo.mapper.HealthDataMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class HealthDataService {

    @Autowired
    private HealthDataMapper healthDataMapper;

    public List<HeartRateCountData> getHeartRateCountData(String userId) {
        return healthDataMapper.getHeartRateCountData(userId);
    };

    public List<HeartRate> getHeartRate(String userId) {
        return healthDataMapper.getHeartRate(userId);
    }

    public List<BloodOxygen> getBloodOxygen(String userId) {
        return healthDataMapper.getBloodOxygen(userId);
    }
    //呼吸率
    public List<Respiration> getRespiration(String userId) {
        return healthDataMapper.getRespiration(userId);
    }
    // 步数
    public List<Steps> getSteps(String userId) {
        return healthDataMapper.getSteps(userId);
    }
    // 睡眠时间
    public List<SleepTime> getSleepTime(String userId) {
        return healthDataMapper.getSleepTime(userId);
    }
    // 血压
    public List<BloodPressure> getBloodPressure(String userId) {
        return healthDataMapper.getBloodPressure(userId);
    }
    // 血糖
    public List<BloodSugar> getBloodSugar(String userId) {
        return healthDataMapper.getBloodSugar(userId);
    }
    public List<uricacid> getUricacid(String userId) {
        return healthDataMapper.getUricacid(userId);
    }
    public List<Cholesterol> getCholesterol(String userId) {
        return healthDataMapper.getCholesterol(userId);
    }

    public List<StepData> getStepData(String userId) {
        return healthDataMapper.getStepData(userId);
    };

    // 公里数
    public List<Distance> getDistance(String userId) {
        return healthDataMapper.getDistance(userId);
    }

    public List<HealthData> getHealthData(String userId) {
        return healthDataMapper.getHealthData(userId);
    }

    // 目标数据
    public List<TargetStep> getTargetStepData(String userId) {
        return healthDataMapper.getTargetStepData(userId);
    };

    public int updateUser(TargetStep targetstep) {
        targetstep.setUserId(targetstep.getUserId());
        targetstep.setTargetStep(targetstep.getTargetStep()); // 关键修复点
        return healthDataMapper.updateStepData(targetstep);
    }


    // 目标运动时间
    public List<SportTime> getSportTime(String userId) {
        return healthDataMapper.getSportTime(userId);
    };

    public int updateSportTime(SportTime sporttime) {
        sporttime.setUserId(sporttime.getUserId());
        sporttime.setSportTime(sporttime.getSportTime()); // 关键修复点
        return healthDataMapper.updateSportTime(sporttime);
    }

    // 目标热量
    public List<Heat> getTargetHeat(String userId) {
        return healthDataMapper.getTargetHeat(userId);
    };

    public int updateTargetHeat(Heat heat) {
        heat.setUserId(heat.getUserId());
        heat.setTargetHeat(heat.getTargetHeat()); // 关键修复点
        return healthDataMapper.updateTargetHeat(heat);
    }

}
