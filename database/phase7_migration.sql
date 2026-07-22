USE advance_care_hospital;

-- Query-path indexes added after reviewing Phase 1–6 screens and reports.
CREATE INDEX idx_jobs_deadline ON career_jobs(is_published,application_deadline,id);
CREATE INDEX idx_job_applicant_email ON job_applications(email,applied_at);
CREATE INDEX idx_ambassador_email ON campus_ambassador_applications(email,applied_at);
CREATE INDEX idx_ai_unanswered_review ON ai_unanswered_queries(status,occurrence_count,last_seen_at);
CREATE INDEX idx_ai_conversation_user ON ai_conversations(user_id,last_message_at);
CREATE INDEX idx_news_public ON news(is_published,published_at);
CREATE INDEX idx_feedback_review ON feedback(status,created_at);
CREATE INDEX idx_contact_review ON contact_messages(status,created_at);

-- Run once. If an index already exists because it was added manually, skip that statement.
