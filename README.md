# Advance Care Specialized Hospital — Phase 1

## Setup with XAMPP

1. Extract the folder into `C:\xampp\htdocs\advance-care-hospital`.
2. Copy `.env.example` and rename the copy to `.env`.
3. In `.env`, use `DB_PORT=3307` if your MySQL runs on 3307; otherwise use 3306.
4. Start Apache and MySQL in XAMPP.
5. Open phpMyAdmin and import `database/schema.sql`.
6. Open a terminal in the project folder and run:

   `C:\xampp\php\php.exe database\create_admin.php admin@advancecare.com StrongPassword123!`

7. Visit `http://localhost/advance-care-hospital/public/`.

Included: PHP MVC routing, PDO database configuration, reusable responsive layout, form validation, patient authentication, password hashing, secure sessions, CSRF protection, roles, middleware, logging and error pages.
