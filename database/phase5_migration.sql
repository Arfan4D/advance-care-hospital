USE advance_care_hospital;

CREATE TABLE IF NOT EXISTS ai_knowledge_base(
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 category VARCHAR(80) NOT NULL,
 question_en VARCHAR(500) NOT NULL,
 answer_en TEXT NOT NULL,
 question_bn VARCHAR(500) NULL,
 answer_bn TEXT NULL,
 keywords_en VARCHAR(500) NOT NULL,
 keywords_bn VARCHAR(500) NULL,
 priority SMALLINT DEFAULT 10,
 is_active BOOLEAN DEFAULT TRUE,
 created_by BIGINT UNSIGNED NULL,
 updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
 FOREIGN KEY(created_by) REFERENCES users(id) ON DELETE SET NULL,
 INDEX idx_ai_category_active(category,is_active,priority)
)ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS symptoms(
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 name_en VARCHAR(150) NOT NULL,
 name_bn VARCHAR(150) NULL,
 keywords_en VARCHAR(500) NOT NULL,
 keywords_bn VARCHAR(500) NULL,
 is_emergency BOOLEAN DEFAULT FALSE,
 emergency_message_en VARCHAR(500) NULL,
 emergency_message_bn VARCHAR(500) NULL,
 is_active BOOLEAN DEFAULT TRUE
)ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS symptom_department_rules(
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 symptom_id BIGINT UNSIGNED NOT NULL,
 department_id BIGINT UNSIGNED NOT NULL,
 recommendation_en VARCHAR(500) NOT NULL,
 recommendation_bn VARCHAR(500) NULL,
 priority SMALLINT DEFAULT 10,
 is_active BOOLEAN DEFAULT TRUE,
 FOREIGN KEY(symptom_id) REFERENCES symptoms(id) ON DELETE CASCADE,
 FOREIGN KEY(department_id) REFERENCES departments(id) ON DELETE CASCADE,
 UNIQUE KEY uq_symptom_department(symptom_id,department_id)
)ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS ai_conversations(
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 conversation_key VARCHAR(64) NOT NULL UNIQUE,
 user_id BIGINT UNSIGNED NULL,
 language ENUM('en','bn') DEFAULT 'en',
 started_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 last_message_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE SET NULL
)ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS ai_messages(
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 conversation_id BIGINT UNSIGNED NOT NULL,
 sender ENUM('user','assistant') NOT NULL,
 message TEXT NOT NULL,
 intent VARCHAR(80) NULL,
 confidence DECIMAL(5,2) NULL,
 metadata JSON NULL,
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 FOREIGN KEY(conversation_id) REFERENCES ai_conversations(id) ON DELETE CASCADE,
 INDEX idx_ai_messages_conversation(conversation_id,created_at)
)ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS ai_unanswered_queries(
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 conversation_id BIGINT UNSIGNED NULL,
 query_text TEXT NOT NULL,
 language ENUM('en','bn') DEFAULT 'en',
 occurrence_count INT UNSIGNED DEFAULT 1,
 status ENUM('new','reviewing','resolved','ignored') DEFAULT 'new',
 resolution_note VARCHAR(500) NULL,
 resolved_by BIGINT UNSIGNED NULL,
 first_seen_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 last_seen_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 FOREIGN KEY(conversation_id) REFERENCES ai_conversations(id) ON DELETE SET NULL,
 FOREIGN KEY(resolved_by) REFERENCES users(id) ON DELETE SET NULL
)ENGINE=InnoDB;

INSERT IGNORE INTO permissions(name,label)VALUES
('ai.manage','Manage AI knowledge and rules'),('ai.reports','Review AI conversations and unanswered questions');
INSERT IGNORE INTO role_permissions(role_id,permission_id)
SELECT r.id,p.id FROM roles r CROSS JOIN permissions p WHERE r.name='admin';

INSERT INTO ai_knowledge_base(category,question_en,answer_en,question_bn,answer_bn,keywords_en,keywords_bn,priority)VALUES
('hours','What are the hospital visiting hours?','The hospital operates 24/7. Doctor visiting schedules vary; open Find a Doctor to check the available days and times.','হাসপাতালের সময়সূচি কী?','হাসপাতাল ২৪ ঘণ্টা খোলা থাকে। চিকিৎসকের সময়সূচি ভিন্ন হতে পারে; সঠিক দিন ও সময় জানতে ডাক্তার খুঁজুন পেজ দেখুন।','visiting hours,opening time,open,hospital hours,doctor time','সময়সূচি,কখন খোলা,ভিজিটিং আওয়ার,ডাক্তার সময়',20),
('appointment','How can I book an appointment?','Log in to your patient account, choose Book Appointment, select a doctor and date, then choose an available time slot.','আমি কীভাবে অ্যাপয়েন্টমেন্ট বুক করব?','রোগীর অ্যাকাউন্টে লগইন করুন, অ্যাপয়েন্টমেন্ট বুক করুন নির্বাচন করুন, ডাক্তার ও তারিখ বেছে নিয়ে খালি সময় নির্বাচন করুন।','book appointment,appointment,booking,schedule doctor','অ্যাপয়েন্টমেন্ট,বুকিং,ডাক্তার বুক,সিরিয়াল',25),
('emergency','How do I contact emergency service?','For an emergency, call the hospital emergency hotline 10678 immediately or contact your local emergency service. Do not wait for chat replies.','জরুরি সেবায় কীভাবে যোগাযোগ করব?','জরুরি অবস্থায় অবিলম্বে হাসপাতালের জরুরি হটলাইন ১০৬৭৮ অথবা স্থানীয় জরুরি সেবায় যোগাযোগ করুন। চ্যাটের উত্তরের জন্য অপেক্ষা করবেন না।','emergency,ambulance,urgent,hotline','জরুরি,অ্যাম্বুলেন্স,ইমার্জেন্সি,হটলাইন',100),
('diagnostics','Where can I find diagnostic test prices?','Open Diagnostic Services to search tests, preparation instructions, estimated report time and sample prices. Confirm final information with the diagnostic desk.','ডায়াগনস্টিক পরীক্ষার মূল্য কোথায় পাব?','ডায়াগনস্টিক সেবা পেজে পরীক্ষা, প্রস্তুতি, রিপোর্টের সম্ভাব্য সময় ও নমুনা মূল্য দেখুন। চূড়ান্ত তথ্য ডায়াগনস্টিক ডেস্ক থেকে নিশ্চিত করুন।','test price,diagnostic,lab test,report time,preparation','পরীক্ষার মূল্য,ডায়াগনস্টিক,ল্যাব টেস্ট,রিপোর্ট,প্রস্তুতি',15),
('cabins','How can I check cabin information?','Open Cabins to compare room types, amenities and sample daily charges. Availability requires confirmation from the admission desk.','কেবিনের তথ্য কীভাবে দেখব?','কেবিন পেজে কক্ষের ধরন, সুবিধা ও দৈনিক নমুনা চার্জ তুলনা করুন। খালি আছে কি না ভর্তি ডেস্ক থেকে নিশ্চিত করতে হবে।','cabin,room,bed,admission,charge','কেবিন,রুম,বেড,ভর্তি,চার্জ',15),
('policy','Does the AI assistant provide diagnosis?','No. The assistant provides hospital information and navigation only. It cannot diagnose, prescribe medicines or replace a qualified healthcare professional.','AI সহকারী কি রোগ নির্ণয় করে?','না। এই সহকারী শুধু হাসপাতালের তথ্য ও সেবা খুঁজতে সাহায্য করে। এটি রোগ নির্ণয়, ওষুধ পরামর্শ বা চিকিৎসকের বিকল্প নয়।','diagnosis,medicine,prescription,medical advice,ai doctor','রোগ নির্ণয়,ওষুধ,প্রেসক্রিপশন,চিকিৎসা পরামর্শ,এআই ডাক্তার',100);

INSERT INTO symptoms(name_en,name_bn,keywords_en,keywords_bn,is_emergency,emergency_message_en,emergency_message_bn)VALUES
('Severe chest pain','তীব্র বুকে ব্যথা','chest pain,severe chest pain,chest pressure,crushing chest pain','বুকে ব্যথা,তীব্র বুকে ব্যথা,বুকে চাপ,বুক চেপে ধরা',1,'Chest pain may require emergency care. Call 10678 or local emergency services now. Do not use chat for urgent assessment.','বুকে ব্যথায় জরুরি চিকিৎসা প্রয়োজন হতে পারে। এখনই ১০৬৭৮ অথবা স্থানীয় জরুরি সেবায় যোগাযোগ করুন।'),
('Difficulty breathing','শ্বাসকষ্ট','difficulty breathing,cannot breathe,severe shortness of breath,blue lips','শ্বাসকষ্ট,শ্বাস নিতে পারছি না,তীব্র শ্বাসকষ্ট,ঠোঁট নীল',1,'Severe breathing difficulty is an emergency warning sign. Call 10678 or local emergency services immediately.','তীব্র শ্বাসকষ্ট জরুরি সতর্কতার লক্ষণ। অবিলম্বে ১০৬৭৮ অথবা স্থানীয় জরুরি সেবায় যোগাযোগ করুন।'),
('Loss of consciousness','অজ্ঞান','unconscious,not waking,fainted and not responding','অজ্ঞান,জ্ঞান নেই,সাড়া দিচ্ছে না',1,'Loss of consciousness requires urgent help. Call emergency services immediately.','অজ্ঞান হলে জরুরি সাহায্য প্রয়োজন। অবিলম্বে জরুরি সেবায় যোগাযোগ করুন।'),
('Stroke warning signs','স্ট্রোকের লক্ষণ','face drooping,arm weakness,sudden speech difficulty,sudden one sided weakness','মুখ বেঁকে যাওয়া,হাত দুর্বল,হঠাৎ কথা জড়িয়ে যাওয়া,এক পাশ অবশ',1,'Possible stroke signs require immediate emergency assessment. Call emergency services now.','সম্ভাব্য স্ট্রোকের লক্ষণে অবিলম্বে জরুরি চিকিৎসা প্রয়োজন। এখনই জরুরি সেবায় যোগাযোগ করুন।'),
('Heart-related concern','হৃদ্‌যন্ত্রের সমস্যা','chest discomfort,palpitations,irregular heartbeat,heart problem','বুকে অস্বস্তি,বুক ধড়ফড়,অনিয়মিত হৃদস্পন্দন,হার্ট সমস্যা',0,NULL,NULL),
('Headache or neurological concern','মাথাব্যথা বা স্নায়বিক সমস্যা','headache,migraine,dizziness,numbness,nerve problem','মাথাব্যথা,মাইগ্রেন,মাথা ঘোরা,অবশ,স্নায়ু সমস্যা',0,NULL,NULL),
('Bone or joint concern','হাড় বা জয়েন্টের সমস্যা','joint pain,knee pain,back pain,bone pain,fracture,sports injury','জয়েন্ট ব্যথা,হাঁটু ব্যথা,কোমর ব্যথা,হাড় ব্যথা,ফ্র্যাকচার',0,NULL,NULL),
('Digestive concern','হজমের সমস্যা','stomach pain,indigestion,gastric,liver problem,abdominal discomfort','পেট ব্যথা,বদহজম,গ্যাস্ট্রিক,লিভার সমস্যা,পেটে অস্বস্তি',0,NULL,NULL),
('Child health concern','শিশুর স্বাস্থ্য সমস্যা','child fever,baby,newborn,child health,pediatric','শিশুর জ্বর,বাচ্চা,নবজাতক,শিশু স্বাস্থ্য',0,NULL,NULL),
('Women health concern','নারী স্বাস্থ্য সমস্যা','pregnancy,women health,menstrual,maternity,gynecology','গর্ভাবস্থা,নারী স্বাস্থ্য,মাসিক,মাতৃত্ব,গাইনি',0,NULL,NULL);

INSERT IGNORE INTO symptom_department_rules(symptom_id,department_id,recommendation_en,recommendation_bn,priority)
SELECT s.id,d.id,'Cardiology may be appropriate for a heart-related concern. This is navigation guidance, not a diagnosis.','হৃদ্‌যন্ত্র সম্পর্কিত সমস্যায় কার্ডিওলজি বিভাগ উপযুক্ত হতে পারে। এটি শুধু বিভাগ খোঁজার নির্দেশনা, রোগ নির্ণয় নয়।',20 FROM symptoms s JOIN departments d ON d.slug='cardiology' WHERE s.name_en='Heart-related concern';
INSERT IGNORE INTO symptom_department_rules(symptom_id,department_id,recommendation_en,recommendation_bn,priority)
SELECT s.id,d.id,'Neurology may be appropriate for headache, dizziness or nerve-related concerns. This is not a diagnosis.','মাথাব্যথা, মাথা ঘোরা বা স্নায়ু সমস্যায় নিউরোলজি বিভাগ উপযুক্ত হতে পারে। এটি রোগ নির্ণয় নয়।',20 FROM symptoms s JOIN departments d ON d.slug='neurology' WHERE s.name_en='Headache or neurological concern';
INSERT IGNORE INTO symptom_department_rules(symptom_id,department_id,recommendation_en,recommendation_bn,priority)
SELECT s.id,d.id,'Orthopedics may be appropriate for bone, joint or mobility concerns.','হাড়, জয়েন্ট বা চলাফেরার সমস্যায় অর্থোপেডিকস বিভাগ উপযুক্ত হতে পারে।',20 FROM symptoms s JOIN departments d ON d.slug='orthopedics' WHERE s.name_en='Bone or joint concern';
INSERT IGNORE INTO symptom_department_rules(symptom_id,department_id,recommendation_en,recommendation_bn,priority)
SELECT s.id,d.id,'Gastroenterology may be appropriate for digestive or liver-related concerns.','হজম বা লিভার সম্পর্কিত সমস্যায় গ্যাস্ট্রোএন্টারোলজি বিভাগ উপযুক্ত হতে পারে।',20 FROM symptoms s JOIN departments d ON d.slug='gastroenterology' WHERE s.name_en='Digestive concern';
INSERT IGNORE INTO symptom_department_rules(symptom_id,department_id,recommendation_en,recommendation_bn,priority)
SELECT s.id,d.id,'Pediatrics may be appropriate for a child-health concern.','শিশুর স্বাস্থ্য সমস্যায় পেডিয়াট্রিকস বিভাগ উপযুক্ত হতে পারে।',20 FROM symptoms s JOIN departments d ON d.slug='pediatrics' WHERE s.name_en='Child health concern';
INSERT IGNORE INTO symptom_department_rules(symptom_id,department_id,recommendation_en,recommendation_bn,priority)
SELECT s.id,d.id,'Gynecology may be appropriate for women’s health or maternity concerns.','নারী স্বাস্থ্য বা মাতৃত্বের সমস্যায় গাইনি বিভাগ উপযুক্ত হতে পারে।',20 FROM symptoms s JOIN departments d ON d.slug='gynecology' WHERE s.name_en='Women health concern';
