# Advance Care Specialized Hospital — Phases 1–7

## Setup with XAMPP

1. Extract the folder into `C:\xampp\htdocs\advance-care-hospital`.
2. Copy `.env.example` and rename the copy to `.env`.
3. In `.env`, use `DB_PORT=3307` if your MySQL runs on 3307; otherwise use 3306.
4. Start Apache and MySQL in XAMPP.
5. Open phpMyAdmin and import `database/schema.sql` first.
6. Import `database/phase2_migration.sql`, `database/phase3_migration.sql`, `database/phase4_migration.sql`, `database/phase5_migration.sql`, `database/phase6_migration.sql`, then `database/phase7_migration.sql`.
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

## Phase 5 AI integration

- Responsive AI chat interface for guests and patients
- Rule-based bilingual English/Bangla responses
- FAQ knowledge base
- Symptom keyword management
- Emergency-keyword detection before ordinary recommendations
- Symptom-to-department navigation rules
- Department and doctor recommendation cards
- Doctor visiting-hour answers
- Hospital policy, diagnostics, cabin and appointment answers
- Login-aware appointment-booking actions
- Conversation and message history
- Unanswered-question collection and occurrence counts
- Admin AI knowledge editor
- Admin symptom and recommendation-rule editor
- Admin unanswered-query review workflow

The assistant is intentionally limited to hospital information and navigation. It does not diagnose conditions, recommend medication, interpret results, or replace professional care.

If Phases 1–4 are already installed, import only `database/phase5_migration.sql`.

## Phase 6 business modules

- Career listings with controlled publishing and deadlines
- Online job applications with secure PDF/DOC/DOCX résumé upload
- Campus Ambassador programs, student applications and admin approval
- Authenticated affiliate registration and private affiliate dashboard
- Referral-link tracking with duplicate visit reduction
- Commission rates, pending/approved/paid records and totals
- Dedicated administrator screens, permissions and audit logging

If Phases 1–5 are already installed, import only `database/phase6_migration.sql`. See `PHASE6_TEST_CHECKLIST.md` before merging or deployment.

## Phase 7 testing and deployment

- Executable database, appointment-conflict, RBAC, upload-security and AI-safety assertions
- Public-route smoke testing and deployment health endpoint
- Responsive, accessibility, performance and security release matrix
- Production security headers, secure-cookie configuration and asset caching
- Additional production query indexes
- Linux and XAMPP database/file backup scripts
- Production environment template, backup restoration and rollback guide

For an existing Phase 6 installation, import only `database/phase7_migration.sql`, run `tests/phase7.php`, then follow `PHASE7_QA_MATRIX.md` and `DEPLOYMENT.md`.

Open the assistant at `/ai-assistant`. Manage it using `/admin/ai-knowledge`, `/admin/ai-symptoms`, and `/admin/ai-unanswered`.

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
