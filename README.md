# Advance Care Specialized Hospital — Phases 1 and 2

## Setup with XAMPP

1. Extract the folder into `C:\xampp\htdocs\advance-care-hospital`.
2. Copy `.env.example` and rename the copy to `.env`.
3. In `.env`, use `DB_PORT=3307` if your MySQL runs on 3307; otherwise use 3306.
4. Start Apache and MySQL in XAMPP.
5. Open phpMyAdmin and import `database/schema.sql` first.
6. Import `database/phase2_migration.sql` into the same database.
7. Open a terminal in the project folder and run:

   `C:\xampp\php\php.exe database\create_admin.php admin@advancecare.com StrongPassword123!`

8. Visit `http://localhost/advance-care-hospital/public/`.

## Phase 2 pages

- Homepage with database content
- About Hospital
- Chairman and Managing Director messages
- Board of Directors and Administration
- Departments and department details
- Searchable Doctors and doctor profiles
- Diagnostic tests and filters
- Healthcare facilities
- Cabins and room information
- Hospital news and articles
- Contact messages and patient feedback
- Consent-controlled YouTube/Facebook patient video reviews

Phase 1 also includes PHP MVC routing, PDO configuration, responsive layouts, validation, authentication, password hashing, secure sessions, CSRF protection, roles, middleware, logging and error pages.

## Add a patient video review

Do not upload video files to the website. Upload publicly to YouTube or Facebook first and obtain written patient consent. Then insert the public URL and official embed URL into `patient_video_reviews`.

YouTube embed example: `https://www.youtube-nocookie.com/embed/VIDEO_ID`

Facebook embed example: `https://www.facebook.com/plugins/video.php?href=URL_ENCODED_PUBLIC_VIDEO_URL&show_text=false`

Only rows with both `consent_recorded=1` and `is_published=1` are visible. Never publish private medical information without explicit consent.
