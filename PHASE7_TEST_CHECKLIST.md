# Phase 7 Release Checklist

- [ ] Import `database/phase7_migration.sql` once.
- [ ] Run PHP lint on every PHP file.
- [ ] Run `php tests/phase7.php` with zero failures.
- [ ] Run the public smoke test with zero failures.
- [ ] Complete every manual test in `PHASE7_QA_MATRIX.md`.
- [ ] Test simultaneous appointment booking from two sessions.
- [ ] Test guest, patient and administrator authorization boundaries.
- [ ] Test résumé MIME validation, size validation and private admin download.
- [ ] Test every emergency keyword in English and Bengali.
- [ ] Test at 320, 375, 768, 1024 and 1440 pixel widths.
- [ ] Complete keyboard, zoom, contrast and screen-reader checks.
- [ ] Record Lighthouse results for five critical pages.
- [ ] Set production `.env`; confirm `APP_DEBUG=false` and HTTPS cookies.
- [ ] Create and restore a pre-deployment backup.
- [ ] Confirm `/health` and core workflows after deployment.

PHP lint from Git Bash on Windows:

```bash
find app routes public database tests -name "*.php" -print0 | xargs -0 -n1 /c/xampp/php/php.exe -l
```
