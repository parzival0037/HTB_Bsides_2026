#!/bin/bash
B=http://10.77.40.50:8080
J='Content-Type: application/json'
echo "=== BEFORE state ==="; curl -sS "$B/api/practice/state"; echo
echo "=== clear hold ==="
curl -sS -i -X POST -H "$J" --data '{"request_id":"t04-hold-clear-1","active":false}' "$B/api/practice/hold"; echo
echo "=== state after hold clear ==="; curl -sS "$B/api/practice/state"; echo
echo "=== request 200L transfer ==="
curl -sS -i -X POST -H "$J" --data '{"request_id":"t04-xfer-200-1","quantity_l":200}' "$B/api/practice/transfer"; echo
for i in $(seq 1 15); do
  sleep 1
  echo "--- poll $i"; curl -sS "$B/api/practice/state"; echo
done
echo "=== AFTER observations ==="; curl -sS "$B/api/practice/observations"; echo
echo "=== AFTER requests ==="; curl -sS "$B/api/practice/requests"; echo
echo "=== re-fetch index ==="; curl -sS "$B/"; echo
echo "=== practice page ==="; curl -sS "$B/practice" | head -20
