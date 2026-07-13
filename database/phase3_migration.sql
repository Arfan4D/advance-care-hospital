USE advance_care_hospital;

CREATE TABLE IF NOT EXISTS patient_profiles(
 user_id BIGINT UNSIGNED PRIMARY KEY,
 date_of_birth DATE NULL,
 gender ENUM('male','female','other','prefer_not_to_say') NULL,
 address VARCHAR(500) NULL,
 emergency_contact_name VARCHAR(120) NULL,
 emergency_contact_phone VARCHAR(20) NULL,
 blood_group VARCHAR(5) NULL,
 updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
 FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE
)ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS verification_codes(
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 user_id BIGINT UNSIGNED NOT NULL,
 channel ENUM('email','phone') NOT NULL,
 code_hash VARCHAR(255) NOT NULL,
 expires_at DATETIME NOT NULL,
 used_at DATETIME NULL,
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE,
 INDEX idx_verification(user_id,channel,expires_at)
)ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS doctor_schedules(
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 doctor_id BIGINT UNSIGNED NOT NULL,
 day_of_week TINYINT UNSIGNED NOT NULL COMMENT '1=Monday, 7=Sunday',
 start_time TIME NOT NULL,
 end_time TIME NOT NULL,
 slot_duration_minutes SMALLINT UNSIGNED NOT NULL DEFAULT 20,
 room_number VARCHAR(30) NULL,
 is_active BOOLEAN DEFAULT TRUE,
 FOREIGN KEY(doctor_id) REFERENCES doctors(id) ON DELETE CASCADE,
 UNIQUE KEY uq_doctor_day_period(doctor_id,day_of_week,start_time,end_time),
 CHECK(day_of_week BETWEEN 1 AND 7)
)ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS doctor_time_slots(
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 schedule_id BIGINT UNSIGNED NOT NULL,
 start_time TIME NOT NULL,
 end_time TIME NOT NULL,
 is_active BOOLEAN DEFAULT TRUE,
 FOREIGN KEY(schedule_id) REFERENCES doctor_schedules(id) ON DELETE CASCADE,
 UNIQUE KEY uq_schedule_slot(schedule_id,start_time)
)ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS appointments(
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 appointment_number VARCHAR(30) NOT NULL UNIQUE,
 patient_id BIGINT UNSIGNED NOT NULL,
 doctor_id BIGINT UNSIGNED NOT NULL,
 department_id BIGINT UNSIGNED NOT NULL,
 appointment_date DATE NOT NULL,
 appointment_time TIME NOT NULL,
 reason VARCHAR(500) NOT NULL,
 status ENUM('pending','confirmed','completed','cancelled','rescheduled','no_show') DEFAULT 'pending',
 consultation_fee DECIMAL(10,2) NOT NULL DEFAULT 0,
 patient_notes TEXT NULL,
 cancelled_at DATETIME NULL,
 cancellation_reason VARCHAR(500) NULL,
 slot_active TINYINT AS (CASE WHEN status IN ('pending','confirmed') THEN 1 ELSE NULL END) STORED,
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
 FOREIGN KEY(patient_id) REFERENCES users(id) ON DELETE RESTRICT,
 FOREIGN KEY(doctor_id) REFERENCES doctors(id) ON DELETE RESTRICT,
 FOREIGN KEY(department_id) REFERENCES departments(id) ON DELETE RESTRICT,
 UNIQUE KEY uq_doctor_active_datetime(doctor_id,appointment_date,appointment_time,slot_active),
 INDEX idx_patient_status(patient_id,status,appointment_date),
 INDEX idx_doctor_date(doctor_id,appointment_date)
)ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS appointment_status_history(
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 appointment_id BIGINT UNSIGNED NOT NULL,
 old_status VARCHAR(30) NULL,
 new_status VARCHAR(30) NOT NULL,
 changed_by BIGINT UNSIGNED NULL,
 note VARCHAR(500) NULL,
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 FOREIGN KEY(appointment_id) REFERENCES appointments(id) ON DELETE CASCADE,
 FOREIGN KEY(changed_by) REFERENCES users(id) ON DELETE SET NULL
)ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS notifications(
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 user_id BIGINT UNSIGNED NOT NULL,
 type VARCHAR(50) NOT NULL DEFAULT 'general',
 title VARCHAR(180) NOT NULL,
 message VARCHAR(500) NOT NULL,
 action_url VARCHAR(255) NULL,
 read_at DATETIME NULL,
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE,
 INDEX idx_user_unread(user_id,read_at,created_at)
)ENGINE=InnoDB;

INSERT IGNORE INTO patient_profiles(user_id)
SELECT u.id FROM users u JOIN user_roles ur ON ur.user_id=u.id JOIN roles r ON r.id=ur.role_id WHERE r.name='patient';

INSERT IGNORE INTO doctor_schedules(doctor_id,day_of_week,start_time,end_time,slot_duration_minutes,room_number)
SELECT id,1,'17:00:00','20:00:00',20,'C-301' FROM doctors WHERE slug='dr-mahmudul-hasan';
INSERT IGNORE INTO doctor_schedules(doctor_id,day_of_week,start_time,end_time,slot_duration_minutes,room_number)
SELECT id,3,'17:00:00','20:00:00',20,'C-301' FROM doctors WHERE slug='dr-mahmudul-hasan';
INSERT IGNORE INTO doctor_schedules(doctor_id,day_of_week,start_time,end_time,slot_duration_minutes,room_number)
SELECT id,7,'16:00:00','19:00:00',20,'N-204' FROM doctors WHERE slug='dr-nusrat-jahan';
INSERT IGNORE INTO doctor_schedules(doctor_id,day_of_week,start_time,end_time,slot_duration_minutes,room_number)
SELECT id,2,'16:00:00','19:00:00',20,'N-204' FROM doctors WHERE slug='dr-nusrat-jahan';
INSERT IGNORE INTO doctor_schedules(doctor_id,day_of_week,start_time,end_time,slot_duration_minutes,room_number)
SELECT id,1,'18:00:00','21:00:00',30,'O-105' FROM doctors WHERE slug='dr-saimul-karim';
INSERT IGNORE INTO doctor_schedules(doctor_id,day_of_week,start_time,end_time,slot_duration_minutes,room_number)
SELECT id,2,'17:00:00','20:00:00',20,'G-402' FROM doctors WHERE slug='dr-afroza-rahman';

INSERT IGNORE INTO doctor_time_slots(schedule_id,start_time,end_time)
SELECT s.id,t.start_time,ADDTIME(t.start_time,SEC_TO_TIME(s.slot_duration_minutes*60))
FROM doctor_schedules s
JOIN (
 SELECT '16:00:00' start_time UNION ALL SELECT '16:20:00' UNION ALL SELECT '16:40:00'
 UNION ALL SELECT '17:00:00' UNION ALL SELECT '17:20:00' UNION ALL SELECT '17:40:00'
 UNION ALL SELECT '18:00:00' UNION ALL SELECT '18:20:00' UNION ALL SELECT '18:30:00' UNION ALL SELECT '18:40:00'
 UNION ALL SELECT '19:00:00' UNION ALL SELECT '19:20:00' UNION ALL SELECT '19:30:00' UNION ALL SELECT '19:40:00'
 UNION ALL SELECT '20:00:00' UNION ALL SELECT '20:30:00'
)t ON t.start_time>=s.start_time AND ADDTIME(t.start_time,SEC_TO_TIME(s.slot_duration_minutes*60))<=s.end_time;
