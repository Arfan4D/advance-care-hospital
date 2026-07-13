# Phase 3 Test Checklist

1. Register a new patient and confirm login succeeds.
2. Update the patient profile and refresh the page.
3. Search doctors by specialty and department.
4. Open Book Appointment, select a doctor and a valid visiting day.
5. Select an available time and submit a reason for visiting.
6. Confirm the appointment reference page appears.
7. Try booking the same doctor, date and time with a second patient; it must be rejected.
8. Check the appointment in dashboard and appointment history.
9. Reschedule it to another available slot.
10. Confirm a notification is created.
11. Cancel the appointment and confirm the slot becomes available again.
12. Confirm one patient cannot open another patient’s appointment ID.

Run PHP syntax checks in Git Bash:

`find app routes public database -name "*.php" -print0 | xargs -0 -n1 /c/xampp/php/php.exe -l`
