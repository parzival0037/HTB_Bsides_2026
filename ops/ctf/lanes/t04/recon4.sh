#!/bin/bash
B=http://10.77.40.50:8080
echo "=== STATE ==="; curl -sS -i --max-time 10 "$B/api/practice/state"; echo
echo "=== REQUESTS ==="; curl -sS -i --max-time 10 "$B/api/practice/requests"; echo
echo "=== OBS ==="; curl -sS -i --max-time 10 "$B/api/practice/observations"; echo
echo "=== options/methods on transfer ==="; curl -sS -i -X OPTIONS --max-time 10 "$B/api/practice/transfer"; echo
echo "=== practice sealed? index listing common paths ==="
for p in practice/sealed practice/sealed.enc practice/flag flag sealed.enc; do
  echo "--- /$p"; curl -sS -o /dev/null -w '%{http_code}\n' --max-time 5 "$B/$p"
done
