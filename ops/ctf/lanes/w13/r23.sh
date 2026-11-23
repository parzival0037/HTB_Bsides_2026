#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
T='fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b'
B=https://support.keplerops.test:8443
J=DIAG-ARWC-F1C3F5B2
echo "=== job before ==="
curl -sS -m 15 $P -k -H "Authorization: Bearer $T" "$B/api/diagnostics/$J" -w '\n[%{http_code}]\n' | head -30
echo "=== put package (match static) ==="
SRC='module.exports={diagnostic_summary:function(req){return {probe:"hello",version:process.version};}};'
python3 - "$SRC" <<'PY' > /tmp/pkg.json
import json,sys
print(json.dumps({"expected_output":{"probe":"hello","version":"v20.0.0"},"interface":"fieldkest.connector/v3","source":sys.argv[1]}))
PY
cat /tmp/pkg.json; echo
curl -sS -m 20 $P -k -X PUT -H "Authorization: Bearer $T" -H 'Content-Type: application/json' --data-binary @/tmp/pkg.json "$B/api/diagnostics/$J/package" -w '\n[%{http_code}]\n' | head -30
echo "=== deliver ==="
curl -sS -m 30 $P -k -X POST -H "Authorization: Bearer $T" -H 'Content-Type: application/json' -d '{}' "$B/api/diagnostics/$J/deliver" -w '\n[%{http_code}]\n' | head -40
echo "=== job after ==="
curl -sS -m 15 $P -k -H "Authorization: Bearer $T" "$B/api/diagnostics/$J" -w '\n[%{http_code}]\n' | head -50
