CREATE TABLE users (
    user_id VARCHAR(32) PRIMARY KEY,
    username VARCHAR(32) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    nick_name VARCHAR(50) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE user_profiles (
    user_id VARCHAR(32) PRIMARY KEY,
    birth_date DATE,
    gender VARCHAR(16),
    height_cm DECIMAL(6, 2),
    weight_kg DECIMAL(6, 2),
    CONSTRAINT fk_profile_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE health_data (
    record_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id VARCHAR(32) NOT NULL,
    data_type VARCHAR(32) NOT NULL,
    timestamp DATETIME NOT NULL,
    created_at DATETIME NOT NULL,
    INDEX idx_health_user_type_time (user_id, data_type, created_at),
    CONSTRAINT fk_health_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE heart_rate_data (
    record_id BIGINT PRIMARY KEY,
    bpm DECIMAL(6, 2) NOT NULL,
    CONSTRAINT fk_heart_rate_record FOREIGN KEY (record_id) REFERENCES health_data(record_id) ON DELETE CASCADE
);

CREATE TABLE blood_oxygen_data (
    record_id BIGINT PRIMARY KEY,
    spo2 DECIMAL(5, 2) NOT NULL,
    CONSTRAINT fk_blood_oxygen_record FOREIGN KEY (record_id) REFERENCES health_data(record_id) ON DELETE CASCADE
);

CREATE TABLE respiration_data (
    record_id BIGINT PRIMARY KEY,
    rpm DECIMAL(5, 2) NOT NULL,
    CONSTRAINT fk_respiration_record FOREIGN KEY (record_id) REFERENCES health_data(record_id) ON DELETE CASCADE
);

CREATE TABLE step_data (
    record_id BIGINT PRIMARY KEY,
    steps INT NOT NULL,
    calories DECIMAL(8, 2) NOT NULL DEFAULT 0,
    distance_m DECIMAL(10, 2) NOT NULL DEFAULT 0,
    activity_type VARCHAR(16) NOT NULL DEFAULT 'WALK',
    duration_min INT NOT NULL DEFAULT 0,
    average_heart_rate DECIMAL(6, 2),
    CONSTRAINT fk_step_record FOREIGN KEY (record_id) REFERENCES health_data(record_id) ON DELETE CASCADE
);

CREATE TABLE sleep_data (
    record_id BIGINT PRIMARY KEY,
    duration_min INT NOT NULL,
    CONSTRAINT fk_sleep_record FOREIGN KEY (record_id) REFERENCES health_data(record_id) ON DELETE CASCADE
);

CREATE TABLE blood_pressure_data (
    record_id BIGINT PRIMARY KEY,
    systolic INT NOT NULL,
    diastolic INT NOT NULL,
    CONSTRAINT fk_blood_pressure_record FOREIGN KEY (record_id) REFERENCES health_data(record_id) ON DELETE CASCADE
);

CREATE TABLE glucose_data (
    record_id BIGINT PRIMARY KEY,
    glucose_mmol DECIMAL(6, 2) NOT NULL,
    CONSTRAINT fk_glucose_record FOREIGN KEY (record_id) REFERENCES health_data(record_id) ON DELETE CASCADE
);

CREATE TABLE uric_acid_data (
    record_id BIGINT PRIMARY KEY,
    uric_acid_umol DECIMAL(8, 2) NOT NULL,
    CONSTRAINT fk_uric_acid_record FOREIGN KEY (record_id) REFERENCES health_data(record_id) ON DELETE CASCADE
);

CREATE TABLE blood_lipid_data (
    record_id BIGINT PRIMARY KEY,
    total_cholesterol DECIMAL(6, 2) NOT NULL,
    CONSTRAINT fk_blood_lipid_record FOREIGN KEY (record_id) REFERENCES health_data(record_id) ON DELETE CASCADE
);

CREATE TABLE target_step (
    user_id VARCHAR(32) PRIMARY KEY,
    targetstep INT NOT NULL DEFAULT 4000,
    CONSTRAINT fk_target_step_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE sport_time_data (
    user_id VARCHAR(32) PRIMARY KEY,
    sporttime INT NOT NULL DEFAULT 60,
    CONSTRAINT fk_sport_time_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE target_heat_data (
    user_id VARCHAR(32) PRIMARY KEY,
    targetheat INT NOT NULL DEFAULT 800,
    CONSTRAINT fk_target_heat_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE habit_checkin (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id VARCHAR(32) NOT NULL,
    habit_type VARCHAR(32) NOT NULL,
    checkin_date DATE NOT NULL,
    count INT NOT NULL DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uk_habit_user_type_date (user_id, habit_type, checkin_date),
    CONSTRAINT fk_habit_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);
