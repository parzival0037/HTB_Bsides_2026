#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
T='fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b'
E=https://10.77.51.60
echo "=== framework endpoints on edge ==="
for p in /openapi.json /docs /redoc /healthz /health /metrics /api/openapi.json /swagger.json /api/v1 /version /favicon.ico /static/app.js /api /api/ /api/status /api/health /api/whoami /api/me /api/integrations /api/v1/health; do
  out=$(curl -sS -m 8 $P -k -H "Authorization: Bearer $T" -w '|%{http_code}' "$E$p" 2>/dev/null)
  code=${out##*|}; body=${out%|*}
  echo "$p -> $code ${body:0:200}"
done
echo "=== HEAD/OPTIONS ==="
curl -sS -m 8 $P -k -I -H "Authorization: Bearer $T" "$E/" 2>&1 | head -10
curl -sS -m 8 $P -k -X OPTIONS -i -H "Authorization: Bearer $T" "$E/" 2>&1 | head -15
echo "=== token variants on edge / ==="
for tok in 'fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b' 'fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'; do
 for hdr in "Authorization: Bearer $tok" "Authorization: Integration $tok" "X-Integration-Token: $tok" "X-FieldKest-Integration: $tok"; do
  echo "--- $hdr"
  curl -sS -m 8 $P -k -H "$hdr" -w ' [%{http_code}]\n' "$E/" 2>&1 | head -3
 done
done
echo "=== no host with bearer ==="
curl -sS -m 8 $P -k -H "Authorization: Bearer $T" -i "$E/" 2>&1 | head -12
