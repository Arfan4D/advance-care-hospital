# Phase 4 Administration Test Checklist

1. Import `database/phase4_migration.sql`.
2. Log in with the administrator account and open `/admin`.
3. Add and edit a doctor; assign a department.
4. Add/edit a department and verify the public page.
5. Create a doctor schedule and confirm time slots are rebuilt.
6. Confirm a pending appointment and verify the patient notification.
7. Complete, cancel, and mark test appointments as no-show.
8. Suspend a test patient and confirm login is blocked; reactivate afterward.
9. Add/edit diagnostic tests, facilities, cabins, news and page content.
10. Add a patient video. Confirm publishing is blocked until consent is recorded.
11. Process a contact message and feedback record.
12. Review reports, roles/permissions and audit logs.
13. Attempt to delete a doctor used by an appointment; the interface should advise deactivation.
14. Run syntax validation:

`find app routes public database -name "*.php" -print0 | xargs -0 -n1 /c/xampp/php/php.exe -l`
