# Production Deployment and Recovery

## 1. Server requirements

- PHP 8.1+ with PDO MySQL, mbstring, fileinfo and JSON
- MySQL 8 or compatible MariaDB
- Apache `mod_rewrite`, `mod_headers` and `mod_expires`
- HTTPS certificate
- Web document root set to the project's `public` directory

## 2. Release preparation

1. Put the repository outside the public web root and expose only `public/`.
2. Copy `.env.production.example` to `.env` and replace every example value.
3. Set `APP_DEBUG=false`, `APP_ENV=production`, the final HTTPS `APP_URL`, `SESSION_SECURE=true`, and a restricted database user.
4. Never commit `.env`, backups, logs or uploaded résumés.
5. Give the web-server account write access only to `storage/logs`, `storage/resumes`, `storage/backups` and approved public upload folders.

Suggested Linux permissions:

```bash
find . -type d -exec chmod 755 {} \;
find . -type f -exec chmod 644 {} \;
chmod -R 750 storage
chmod -R 770 storage/logs storage/resumes storage/backups public/uploads
```

## 3. Database deployment

Back up first. Import migrations in numerical order. For an existing Phase 6 installation, import only `database/phase7_migration.sql`. Create a least-privilege application database account instead of using MySQL root.

```sql
CREATE USER 'advancecare_app'@'localhost' IDENTIFIED BY 'LONG_RANDOM_PASSWORD';
GRANT SELECT,INSERT,UPDATE,DELETE ON advance_care_hospital.* TO 'advancecare_app'@'localhost';
FLUSH PRIVILEGES;
```

Migration accounts may temporarily require ALTER/INDEX privileges; the runtime account should not.

## 4. Release verification

```bash
php tests/phase7.php
bash scripts/smoke-test.sh https://hospital.example.com
curl -fsS https://hospital.example.com/health
```

Then complete `PHASE7_QA_MATRIX.md`. Check PHP/Apache logs without exposing them publicly.

## 5. Backups

Linux cron example (daily at 02:15):

```cron
15 2 * * * /var/www/advance-care-hospital/scripts/backup.sh >> /var/log/advance-care-backup.log 2>&1
```

On XAMPP, run `scripts/backup-xampp.bat` with Windows Task Scheduler. Store an encrypted copy off-server. Database and files must be backed up together. Test restoration monthly.

Restore example:

```bash
gunzip -c storage/backups/database-TIMESTAMP.sql.gz | mysql -u advancecare_app -p advance_care_hospital
tar -xzf storage/backups/uploads-TIMESTAMP.tar.gz -C .
```

## 6. Rollback

Before every release, record the Git commit and create a backup. If verification fails: enable a maintenance page, restore the previous application commit, restore the matching database/files backup when schema or data changed, run `/health` and smoke tests, then reopen traffic.

## 7. Operational monitoring

- Monitor `/health` for HTTP 200 without exposing credentials or record counts.
- Alert on repeated HTTP 500 responses, database failures and backup failures.
- Review unanswered AI questions and emergency rules regularly.
- Review audit logs, failed login attempts, storage growth and expiring job/program dates.
