#!/bin/bash
set -euo pipefail

STATUS=$(curl -o /dev/null -s -w "%{http_code}" --max-time 15 "$SERVER_URL" || echo "000")

if [ "$STATUS" -ge 200 ] && [ "$STATUS" -lt 400 ]; then
  echo "Servidor OK (status $STATUS)"
else
  MESSAGE="🔴 ALERTA: $SERVER_URL parece estar fora do ar (status: $STATUS) - $(date -u '+%d/%m/%Y %H:%M UTC')"
  curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
    -d chat_id="${TELEGRAM_CHAT_ID}" \
    -d text="$MESSAGE" > /dev/null
  echo "Servidor fora do ar (status $STATUS) - alerta enviado"
  exit 1
fi
