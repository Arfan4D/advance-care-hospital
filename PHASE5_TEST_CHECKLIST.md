# Phase 5 AI Test Checklist

1. Import `database/phase5_migration.sql` once.
2. Open `/ai-assistant` as a guest.
3. Ask “How can I book an appointment?” and confirm the login/booking action.
4. Ask “Which department for headache?” and confirm Neurology plus stored doctors appear.
5. Ask the same question in Bangla: “মাথাব্যথার জন্য কোন বিভাগে যাব?”
6. Test doctor schedule wording using a stored doctor’s name.
7. Test hospital hours, diagnostic prices and cabin information.
8. Test “severe chest pain” and “শ্বাস নিতে পারছি না”; emergency guidance must appear before any department recommendation.
9. Ask an unknown question and confirm it appears under `/admin/ai-unanswered`.
10. Add a bilingual FAQ in `/admin/ai-knowledge`, then retest it.
11. Add a non-emergency symptom rule and connect it to a department.
12. Confirm every recommendation includes navigation-only wording and never claims a diagnosis.
13. Confirm patient and guest conversations remain separated by session.
14. Run PHP syntax checking:

`find app routes public database -name "*.php" -print0 | xargs -0 -n1 /c/xampp/php/php.exe -l`
