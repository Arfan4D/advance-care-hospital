USE advance_care_hospital;

-- Replace VIDEO_ID and the patient information before running.
-- Written consent is required before setting consent_recorded and is_published to 1.
INSERT INTO patient_video_reviews
(title,patient_name,department_id,platform,video_url,embed_url,description,consent_recorded,is_featured,is_published,published_at)
VALUES
('Patient Care Experience','Verified Patient',NULL,'youtube',
 'https://www.youtube.com/watch?v=VIDEO_ID',
 'https://www.youtube-nocookie.com/embed/VIDEO_ID',
 'A publicly shared patient experience.',1,1,1,NOW());
