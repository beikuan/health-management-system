package com.example.demo.service;

import com.example.demo.domain.*;
import com.example.demo.mapper.StatisticalMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 健康数据原始记录服务实现类
 * 实现对血氧、心率、呼吸频率、步数、尿酸、血压等记录的查询
 */
@Service
public class StatisticalService {

    @Autowired
    private StatisticalMapper statisticalMapper;

    /**
     * 获取用户血氧记录列表
     */
    public List<BloodOxygenCountData> getBloodOxygenCountData(String userId) {
        return statisticalMapper.getBloodOxygenCountData(userId);
    }

    /**
     * 获取用户心率记录列表
     */
    public List<HeartRateRecord> getHeartRateRecord(String userId) {
        return statisticalMapper.getHeartRateRecord(userId);
    }

    /**
     * 获取用户呼吸频率记录列表
     */
    public List<RespirationCountData> getRespirationCountData(String userId) {
        return statisticalMapper.getRespirationCountData(userId);
    }

    /**
     * 获取用户步数记录列表
     */
    public List<StepCountData> getStepCountData(String userId) {

        return statisticalMapper.getStepCountData(userId);
    }

    /**
     * 获取用户血压记录列表（包含收缩压/舒张压）
     */
    public List<BloodPressureCountData> getBloodPressureCountData(String userId) {
        return statisticalMapper.getBloodPressureCountData(userId);
    }

    /**
     * 获取用户尿酸记录列表
     */
    public List<UricAcidCountData> getUricAcidCountData(String userId) {
        return statisticalMapper.getUricAcidCountData(userId);
    }
}
