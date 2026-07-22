USE advance_care_hospital;

CREATE TABLE IF NOT EXISTS settings(
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 setting_key VARCHAR(120) NOT NULL UNIQUE,
 setting_value TEXT NULL,
 setting_group VARCHAR(80) NOT NULL DEFAULT 'general',
 is_public BOOLEAN DEFAULT FALSE,
 updated_by BIGINT UNSIGNED NULL,
 updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
 FOREIGN KEY(updated_by) REFERENCES users(id) ON DELETE SET NULL
)ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS admin_notes(
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 entity_type VARCHAR(80) NOT NULL,
 entity_id BIGINT UNSIGNED NOT NULL,
 note TEXT NOT NULL,
 created_by BIGINT UNSIGNED NULL,
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 FOREIGN KEY(created_by) REFERENCES users(id) ON DELETE SET NULL,
 INDEX idx_admin_note_entity(entity_type,entity_id)
)ENGINE=InnoDB;

INSERT IGNORE INTO permissions(name,label)VALUES
('doctors.manage','Manage doctors'),
('departments.manage','Manage departments'),
('schedules.manage','Manage doctor schedules'),
('patients.manage','Manage patients'),
('diagnostics.manage','Manage diagnostic tests'),
('facilities.manage','Manage facilities'),
('cabins.manage','Manage cabins'),
('news.manage','Manage news and content'),
('videos.manage','Manage patient video reviews'),
('feedback.manage','Manage contact messages and feedback'),
('reports.view','View reports'),
('roles.manage','Manage roles and permissions'),
('audit.view','View audit logs');

INSERT IGNORE INTO role_permissions(role_id,permission_id)
SELECT r.id,p.id FROM roles r CROSS JOIN permissions p WHERE r.name='admin';

INSERT IGNORE INTO settings(setting_key,setting_value,setting_group,is_public)VALUES
('hospital_name','Advance Care Specialized Hospital','general',1),
('emergency_hotline','10678','contact',1),
('ambulance_phone','01713-106787','contact',1),
('appointment_confirmation_message','Your appointment request is pending hospital confirmation.','appointment',1),
('patient_video_disclaimer','Patient experiences vary and do not guarantee identical outcomes.','content',1);
