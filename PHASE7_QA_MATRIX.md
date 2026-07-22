# Phase 7 Quality Assurance Matrix

| Area | Automated evidence | Manual acceptance test |
|---|---|---|
| Functional | `scripts/smoke-test.sh`; `tests/phase7.php` schema checks | Complete registration, login, appointment, career, ambassador and affiliate workflows |
| Database | Required-table, index and permission assertions | Import migrations on a clean database and inspect foreign keys in phpMyAdmin |
| Appointment conflict | Transactional duplicate insert must return SQLSTATE 23000 | Submit the same doctor/date/time from two browser sessions; exactly one succeeds |
| Authorization | Admin/patient permission assertions | Guest → login redirect; patient → 403 on every `/admin/*` route; admin succeeds |
| Upload security | Private storage path and Apache execution-block assertions | Test valid PDF/DOC/DOCX and reject PHP, renamed executable, image and >5 MB files |
| AI recommendations | Bilingual knowledge and intent-order assertions | Test every seeded symptom in English and Bengali; verify department/doctor cards |
| Emergency response | Emergency rules and emergency-first assertion | Test chest pain, breathing difficulty, unconsciousness and stroke wording in both languages |
| Responsive | CSS breakpoints and flexible grids | Chrome DevTools: 320, 375, 768, 1024 and 1440 px; no horizontal overflow |
| Accessibility | Semantic labels, iframe titles, live chat region | Keyboard-only navigation, 200% zoom, visible focus, screen-reader labels, contrast check |
| Performance | Cache headers, lazy video embeds and Phase 7 indexes | Lighthouse mobile: Performance ≥80, Accessibility ≥90, Best Practices ≥90 |
| Backup/recovery | Bash and XAMPP backup scripts | Restore the newest SQL backup and verify login, appointments and uploaded résumés |

## Required release rule

Do not deploy if any automated test fails, an emergency prompt produces a normal department response, duplicate active appointments are accepted, a patient can access an admin route, or an executable upload is accepted.

## Commands

```bash
C:/xampp/php/php.exe tests/phase7.php
bash scripts/smoke-test.sh http://localhost/advance-care-hospital/public
```

Run Lighthouse from Chrome DevTools against Home, Doctors, Appointment, AI Assistant and Careers. Save screenshots/results with the team submission.
