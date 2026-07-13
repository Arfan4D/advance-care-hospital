# Advance Care Specialized Hospital — Phases 1–4

## Setup with XAMPP

1. Extract the folder into `C:\xampp\htdocs\advance-care-hospital`.
2. Copy `.env.example` and rename the copy to `.env`.
3. In `.env`, use `DB_PORT=3307` if your MySQL runs on 3307; otherwise use 3306.
4. Start Apache and MySQL in XAMPP.
5. Open phpMyAdmin and import `database/schema.sql` first.
6. Import `database/phase2_migration.sql`, `database/phase3_migration.sql`, then `database/phase4_migration.sql`.
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

## Phase 3 patient and appointment system

- Patient registration and secure login/logout
- Patient dashboard and profile management
- Doctor search and filters
- Weekly doctor schedules and selectable time slots
- Appointment booking with transactional duplicate prevention
- Appointment reference and confirmation page
- Appointment history and status filters
- Patient-owned cancellation and rescheduling
- Slot release after cancellation
- In-app appointment notifications and read status
- Verification-code database foundation

Account verification is disabled for local XAMPP development because no SMTP email or SMS provider is configured. The `verification_codes` table is ready for a future provider. Do not simulate sending verification messages in production.

## Phase 4 administration panel

- Dashboard metrics and recent appointments
- Doctor CRUD with department assignment
- Department CRUD
- Schedule management with automatic time-slot generation
- Appointment confirmation, completion, cancellation and no-show workflow
- Patient account activation/suspension
- Diagnostic-test management
- Facility and cabin management
- News and page-content management
- Consent-controlled YouTube/Facebook patient video management
- Contact-message and patient-feedback workflows
- Monthly, department and doctor reports
- Custom roles and permission matrix
- Read-only administrative audit logs

If Phases 1–3 are already installed, import only `database/phase4_migration.sql`.

Open the admin panel at `/admin`. Existing administrators automatically receive all newly added Phase 4 permissions.

## Upgrade an existing Phase 2 database

If Phase 1 and Phase 2 are already installed, import only:

`database/phase3_migration.sql`

Do not import `schema.sql` or `phase2_migration.sql` again.

After importing, log in as a patient and test:

- `/dashboard`
- `/profile`
- `/doctors`
- `/book-appointment`
- `/appointments`
- `/notifications`

## Add a patient video review

Do not upload video files to the website. Upload publicly to YouTube or Facebook first and obtain written patient consent. Then insert the public URL and official embed URL into `patient_video_reviews`.

YouTube embed example: `https://www.youtube-nocookie.com/embed/VIDEO_ID`

Facebook embed example: `https://www.facebook.com/plugins/video.php?href=URL_ENCODED_PUBLIC_VIDEO_URL&show_text=false`

Only rows with both `consent_recorded=1` and `is_published=1` are visible. Never publish private medical information without explicit consent.
