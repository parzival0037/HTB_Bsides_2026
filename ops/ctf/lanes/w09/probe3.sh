#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080 -k -sS -m 30"
T=fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo
echo "== pivot"
curl $P -o /dev/null -w '%{http_code}\n' https://source.keplerops.test/
echo "== repos"
curl $P -H "Authorization: token $T" "https://source.keplerops.test/api/v1/user/repos?limit=100" -o /tmp/repos.json -w '%{http_code}\n'
python3 - <<'PY'
import json
d=json.load(open("/tmp/repos.json"))
print(len(d))
for r in d: print(r["full_name"],"|",r.get("description"))
PY
echo "== search connector"
curl $P -H "Authorization: token $T" "https://source.keplerops.test/api/v1/repos/search?q=arwc&limit=50" | head -c 1500
echo
echo "== jenkins"
curl $P -u rowan.ito:$T "https://ci.keplerops.test/job/fieldlink-report/1842/api/json" | head -c 2000
echo
curl $P -u rowan.ito:$T "https://ci.keplerops.test/job/fieldlink-report/1842/consoleText" | tail -60
echo "== connector headers"
curl $P -i https://connector.arwc.test/ | head -20
echo "== connector options"
curl $P -i -X OPTIONS https://connector.arwc.test/ | head -20
