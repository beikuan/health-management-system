package com.example.demo.mapper;


import com.example.demo.domain.*;

import java.util.List;
public interface StatisticalMapper {
    List<BloodOxygenCountData> getBloodOxygenCountData(String userId);
    List<HeartRateRecord> getHeartRateRecord(String userId);
    List<RespirationCountData>  getRespirationCountData(String userId);
    List<StepCountData> getStepCountData(String userId);
    List<UricAcidCountData > getUricAcidCountData(String userId);
    List<BloodPressureCountData> getBloodPressureCountData(String userId);
}
