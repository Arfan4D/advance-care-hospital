# Phase 6 Test Checklist

1. Import `database/phase6_migration.sql` once after the Phase 1–5 migrations.
2. Open `/careers`, view the seeded Medical Officer listing and submit an application.
3. Test a PDF, DOC and DOCX résumé under 5 MB; reject executable, image and oversized files.
4. Confirm the submitted job appears at `/admin/business-applications?type=jobs` and update each workflow status.
5. Create or edit a job at `/admin/business-jobs`; confirm unpublished and expired jobs are hidden publicly.
6. Open `/campus-ambassador`, submit a student application and review it at `/admin/business-applications?type=ambassadors`.
7. Create a program at `/admin/business-programs` and confirm it displays publicly.
8. Log in as a patient, register at `/affiliate`, and confirm the initial status is Pending.
9. As admin, approve the affiliate at `/admin/business-affiliates` and set a commission rate.
10. Open the generated referral link in a private browser and confirm the referral count increases once per browser/day.
11. Add pending, approved and paid commissions; confirm totals and history in `/affiliate/dashboard`.
12. Confirm a user cannot view another affiliate's dashboard and non-admins receive 403 for admin routes.
13. Confirm all POST forms reject missing/invalid CSRF tokens.
14. Run PHP syntax checking from Git Bash:

```bash
find app routes public database -name "*.php" -print0 | xargs -0 -n1 /c/xampp/php/php.exe -l
```
