#!/bin/bash
set +e
P="--socks5-hostname 127.0.0.1:1080 -k -sS -m 20"
T=fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo
echo "== pivot"
curl $P -o /dev/null -w '%{http_code}\n' https://source.keplerops.test/
echo "== gitea repos"
curl $P -u rowan.ito:$T "https://source.keplerops.test/api/v1/repos/search?limit=100&sort=updated" -o /tmp/repos.json -w '%{http_code}\n'
python3 - <<'PY'
import json
d=json.load(open('/tmp/repos.json'))
for r in d.get('data',[]):
    print(r['full_name'],'|',r.get('description'),'|',r.get('updated_at'))
PY
echo "== jenkins jobs"
curl $P -u rowan.ito:$T "https://ci.keplerops.test/api/json?tree=jobs[name,url,color]" | python3 -c 'import sys,json;d=json.load(sys.stdin);[print(j["name"],j["color"]) for j in d.get("jobs",[])]'
echo "== s3"
which aws || pip list 2>/dev/null | grep -i boto
aws --endpoint-url https://objects.keplerops.test s3 ls 2>&1 | head -20
echo DONE
