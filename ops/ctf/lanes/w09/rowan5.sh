#!/bin/bash
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=10 rowan-dev"
$S 'set -x
echo "===== map strings api"
grep -aoE "/(api|v[0-9])[A-Za-z0-9_./{}-]{2,60}" ~/repos/connector-archive/connector-archive/maps/fieldlink-connector-6.9.8.map 2>/dev/null | sort -u | head -100
echo "===== map strings arwc"
grep -aoiE "[A-Za-z0-9_./-]*arwc[A-Za-z0-9_./-]*" ~/repos/connector-archive/connector-archive/maps/fieldlink-connector-6.9.8.map 2>/dev/null | sort -u | head -60
echo "===== notes"
cat ~/repos/connector-archive/connector-archive/notes/retained-diagnostic.md
cat ~/repos/connector-archive/connector-archive/config/*.conf
echo "===== internal md"
cat ~/repos/connector-archive/connector-archive/internal/fieldlink/legacy-diagnostics/CRR-OG2/ENG-FLK-LEGACY-42.md
cat ~/repos/connector-archive/connector-archive/internal/fieldlink/legacy-diagnostics/CRR-OG2/ENT-ARWC-DIAG-0698.json
echo "===== gitea repos"
T=fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo
curl -sS --socks5-hostname 127.0.0.1:1080 -k -m 30 -H "Authorization: token $T" "https://source.keplerops.test/api/v1/user/repos?limit=100" -o /tmp/repos.json
python3 - <<PY
import json
d=json.load(open("/tmp/repos.json"))
print(len(d))
for r in d: print(r["full_name"], r.get("description"))
PY
echo "===== gitea search arwc"
curl -sS --socks5-hostname 127.0.0.1:1080 -k -m 30 -H "Authorization: token $T" "https://source.keplerops.test/api/v1/repos/search?q=arwc&limit=50" | head -c 2000
echo
' 2>&1 | tail -200
