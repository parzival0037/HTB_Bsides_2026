#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
T='fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b'
E=https://10.77.51.60
echo "=== /api/session variants ==="
for m in GET POST PUT PATCH DELETE; do
  for auth in "" "Authorization: Bearer $T"; do
    echo "--- $m [$auth]"
    curl -sS -m 10 $P -k -X $m ${auth:+-H "$auth"} -H 'Content-Type: application/json' -d '{}' -i "$E/api/session" 2>&1 | head -18
  done
done
echo "=== /api/session/ and children ==="
for p in /api/session /api/session/ /api/session/current /api/sessions /api/login /api/token; do
 out=$(curl -sS -m 8 $P -k -H "Authorization: Bearer $T" -w '|%{http_code}' "$E$p" 2>/dev/null)
 echo "$p -> ${out##*|} ${out%|*}"
done
echo "=== gobuster raft-small-words on /api ==="
timeout 420 gobuster dir -u https://10.77.51.60/api -k --proxy socks5://127.0.0.1:1080 -H "Authorization: Bearer $T" -w /usr/share/seclists/Discovery/Web-Content/raft-small-words.txt -b 404 -t 25 --timeout 8s --no-error 2>&1 | tail -70
