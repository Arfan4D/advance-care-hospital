#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
set -a
source "$ROOT/.env"
set +a
BACKUP_DIR="${BACKUP_DIR:-$ROOT/storage/backups}"
RETENTION="${BACKUP_RETENTION_DAYS:-14}"
mkdir -p "$BACKUP_DIR"
STAMP="$(date +%Y%m%d-%H%M%S)"
MYSQLDUMP_BIN="${MYSQLDUMP_BIN:-mysqldump}"
MYSQL_PWD="${DB_PASSWORD:-}" "$MYSQLDUMP_BIN" --host="${DB_HOST:-127.0.0.1}" --port="${DB_PORT:-3306}" --user="${DB_USERNAME:-root}" --single-transaction --routines --triggers --default-character-set=utf8mb4 "${DB_DATABASE:-advance_care_hospital}" | gzip > "$BACKUP_DIR/database-$STAMP.sql.gz"
tar -czf "$BACKUP_DIR/uploads-$STAMP.tar.gz" -C "$ROOT" public/uploads storage/resumes
find "$BACKUP_DIR" -type f -mtime "+$RETENTION" -delete
echo "Backup completed: $STAMP"
