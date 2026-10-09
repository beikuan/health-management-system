package com.example.demo.mapper;

import com.example.demo.domain.HealthRecordEntity;
import com.example.demo.dto.HealthRecordRequest;
import com.example.demo.dto.HealthRecordResponse;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface HealthRecordMapper {
    @Insert("INSERT INTO health_data (user_id, data_type, timestamp, created_at) " +
            "VALUES (#{userId}, #{dataType}, #{recordedAt}, #{recordedAt})")
    @Options(useGeneratedKeys = true, keyProperty = "recordId")
    int insertRecord(HealthRecordEntity record);

    @Insert("INSERT INTO heart_rate_data (record_id, bpm) VALUES (#{id}, #{r.bpm})")
    int insertHeartRate(@Param("id") Long id, @Param("r") HealthRecordRequest request);
    @Insert("INSERT INTO blood_oxygen_data (record_id, spo2) VALUES (#{id}, #{r.spo2})")
    int insertBloodOxygen(@Param("id") Long id, @Param("r") HealthRecordRequest request);
    @Insert("INSERT INTO respiration_data (record_id, rpm) VALUES (#{id}, #{r.rpm})")
    int insertRespiration(@Param("id") Long id, @Param("r") HealthRecordRequest request);
    @Insert("INSERT INTO step_data (record_id, steps, calories, distance_m, activity_type, duration_min, average_heart_rate) " +
            "VALUES (#{id}, #{r.steps}, #{r.calories}, #{r.distanceM}, #{r.activityType}, #{r.durationMin}, #{r.averageHeartRate})")
    int insertSteps(@Param("id") Long id, @Param("r") HealthRecordRequest request);
    @Insert("INSERT INTO sleep_data (record_id, duration_min) VALUES (#{id}, #{r.durationMin})")
    int insertSleep(@Param("id") Long id, @Param("r") HealthRecordRequest request);
    @Insert("INSERT INTO blood_pressure_data (record_id, systolic, diastolic) VALUES (#{id}, #{r.systolic}, #{r.diastolic})")
    int insertBloodPressure(@Param("id") Long id, @Param("r") HealthRecordRequest request);
    @Insert("INSERT INTO glucose_data (record_id, glucose_mmol) VALUES (#{id}, #{r.glucoseMmol})")
    int insertGlucose(@Param("id") Long id, @Param("r") HealthRecordRequest request);
    @Insert("INSERT INTO uric_acid_data (record_id, uric_acid_umol) VALUES (#{id}, #{r.uricAcidUmol})")
    int insertUricAcid(@Param("id") Long id, @Param("r") HealthRecordRequest request);
    @Insert("INSERT INTO blood_lipid_data (record_id, total_cholesterol) VALUES (#{id}, #{r.totalCholesterol})")
    int insertBloodLipid(@Param("id") Long id, @Param("r") HealthRecordRequest request);

    @Select("""
            <script>
            SELECT hd.record_id AS recordId, hd.data_type AS type, hd.created_at AS recordedAt,
                   hr.bpm, bo.spo2, rp.rpm, st.steps, st.calories, st.distance_m AS distanceM,
                   st.activity_type AS activityType, COALESCE(st.duration_min, sl.duration_min) AS durationMin,
                   st.average_heart_rate AS averageHeartRate, bp.systolic, bp.diastolic,
                   gl.glucose_mmol AS glucoseMmol, ua.uric_acid_umol AS uricAcidUmol,
                   bl.total_cholesterol AS totalCholesterol
            FROM health_data hd
            LEFT JOIN heart_rate_data hr ON hr.record_id = hd.record_id
            LEFT JOIN blood_oxygen_data bo ON bo.record_id = hd.record_id
            LEFT JOIN respiration_data rp ON rp.record_id = hd.record_id
            LEFT JOIN step_data st ON st.record_id = hd.record_id
            LEFT JOIN sleep_data sl ON sl.record_id = hd.record_id
            LEFT JOIN blood_pressure_data bp ON bp.record_id = hd.record_id
            LEFT JOIN glucose_data gl ON gl.record_id = hd.record_id
            LEFT JOIN uric_acid_data ua ON ua.record_id = hd.record_id
            LEFT JOIN blood_lipid_data bl ON bl.record_id = hd.record_id
            WHERE hd.user_id = #{userId}
            <if test="type != null and type != ''">AND hd.data_type = #{type}</if>
            ORDER BY hd.created_at DESC
            LIMIT 100
            </script>
            """)
    List<HealthRecordResponse> listRecords(@Param("userId") String userId, @Param("type") String type);

    @Delete("DELETE FROM health_data WHERE record_id = #{recordId} AND user_id = #{userId}")
    int deleteOwned(@Param("recordId") Long recordId, @Param("userId") String userId);
}
