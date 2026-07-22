@echo off
setlocal EnableExtensions
set ROOT=%~dp0..
if not exist "%ROOT%\storage\backups" mkdir "%ROOT%\storage\backups"
for /f %%i in ('powershell -NoProfile -Command "Get-Date -Format yyyyMMdd-HHmmss"') do set STAMP=%%i
set MYSQLDUMP=C:\xampp\mysql\bin\mysqldump.exe
REM Update port, username and password for your local/production database.
"%MYSQLDUMP%" -h 127.0.0.1 -P 3307 -u root --single-transaction --routines --triggers --default-character-set=utf8mb4 advance_care_hospital > "%ROOT%\storage\backups\database-%STAMP%.sql"
if errorlevel 1 (echo Backup failed.& exit /b 1)
echo Database backup completed: %STAMP%
