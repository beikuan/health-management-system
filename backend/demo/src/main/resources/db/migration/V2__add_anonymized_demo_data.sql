INSERT INTO users (user_id, username, password, email, nick_name)
VALUES ('demo-user-001', 'demo', '$2a$10$aukD5ZCgU1x5D5CRp5M8pu/aLWpZzBhdTlB6r7/s8t2N9pOCowsse',
        'demo@example.invalid', '演示用户');

INSERT INTO user_profiles (user_id, birth_date, gender, height_cm, weight_kg)
VALUES ('demo-user-001', '1995-01-01', '保密', 170.00, 65.00);

INSERT INTO target_step (user_id, targetstep) VALUES ('demo-user-001', 4000);
INSERT INTO target_heat_data (user_id, targetheat) VALUES ('demo-user-001', 800);
INSERT INTO sport_time_data (user_id, sporttime) VALUES ('demo-user-001', 60);

INSERT INTO habit_checkin (user_id, habit_type, checkin_date, count) VALUES
('demo-user-001', '喝水', CURRENT_DATE, 3),
('demo-user-001', '刷牙', CURRENT_DATE, 1),
('demo-user-001', '早起', CURRENT_DATE, 1),
('demo-user-001', '跑步', CURRENT_DATE, 0);

INSERT INTO health_data (record_id, user_id, data_type, timestamp, created_at) VALUES
(1001, 'demo-user-001', 'HEART_RATE', NOW() - INTERVAL 2 HOUR, NOW() - INTERVAL 2 HOUR),
(1002, 'demo-user-001', 'BLOOD_OXYGEN', NOW() - INTERVAL 2 HOUR, NOW() - INTERVAL 2 HOUR),
(1003, 'demo-user-001', 'RESPIRATION', NOW() - INTERVAL 2 HOUR, NOW() - INTERVAL 2 HOUR),
(1004, 'demo-user-001', 'SLEEP', NOW() - INTERVAL 8 HOUR, NOW() - INTERVAL 8 HOUR),
(1005, 'demo-user-001', 'BLOOD_PRESSURE', NOW() - INTERVAL 2 HOUR, NOW() - INTERVAL 2 HOUR),
(1006, 'demo-user-001', 'BLOOD_GLUCOSE', NOW() - INTERVAL 2 HOUR, NOW() - INTERVAL 2 HOUR),
(1007, 'demo-user-001', 'URIC_ACID', NOW() - INTERVAL 2 HOUR, NOW() - INTERVAL 2 HOUR),
(1008, 'demo-user-001', 'BLOOD_LIPID', NOW() - INTERVAL 2 HOUR, NOW() - INTERVAL 2 HOUR),
(1009, 'demo-user-001', 'STEPS', NOW() - INTERVAL 1 DAY, NOW() - INTERVAL 1 DAY),
(1010, 'demo-user-001', 'STEPS', NOW(), NOW());

INSERT INTO heart_rate_data (record_id, bpm) VALUES (1001, 72);
INSERT INTO blood_oxygen_data (record_id, spo2) VALUES (1002, 98);
INSERT INTO respiration_data (record_id, rpm) VALUES (1003, 16);
INSERT INTO sleep_data (record_id, duration_min) VALUES (1004, 450);
INSERT INTO blood_pressure_data (record_id, systolic, diastolic) VALUES (1005, 118, 76);
INSERT INTO glucose_data (record_id, glucose_mmol) VALUES (1006, 5.20);
INSERT INTO uric_acid_data (record_id, uric_acid_umol) VALUES (1007, 320);
INSERT INTO blood_lipid_data (record_id, total_cholesterol) VALUES (1008, 4.60);
INSERT INTO step_data (record_id, steps, calories, distance_m, activity_type, duration_min, average_heart_rate) VALUES
(1009, 3200, 210, 2400, 'WALK', 35, 96),
(1010, 1800, 155, 2100, 'RUN', 18, 132);
