#!/usr/bin/env bash
set -euo pipefail
BASE_URL="${1:-http://localhost/advance-care-hospital/public}"
pages=("" "about" "departments" "doctors" "diagnostics" "facilities" "cabins" "news" "patient-stories" "careers" "campus-ambassador" "ai-assistant" "contact" "health")
failed=0
for page in "${pages[@]}"; do
  code="$(curl -L -sS -o /dev/null -w '%{http_code}' "$BASE_URL/$page")"
  if [[ "$code" == "200" ]]; then echo "PASS $code /$page"; else echo "FAIL $code /$page"; failed=1; fi
done
exit "$failed"
