#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
B=https://source.keplerops.test
T=fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo
A="-u rowan.ito:$T"
curl -sS $P -k --max-time 20 $A "$B/api/v1/user/repos?limit=50" -o /tmp/gr.json
python3 - <<'PY'
import json
d=json.load(open('/tmp/gr.json'))
for r in d: print(r['full_name'],'|',r.get('description'),'| private',r['private'],'| updated',r['updated_at'])
PY
for repo in $(python3 -c "import json;print(' '.join(r['full_name'] for r in json.load(open('/tmp/gr.json'))))"); do
  echo "##### ISSUES $repo"; sleep 1
  curl -sS $P -k --max-time 20 $A "$B/api/v1/repos/$repo/issues?state=all&limit=50" -o /tmp/gi.json
  python3 - <<'PY'
import json
try: d=json.load(open('/tmp/gi.json'))
except Exception as e: print('ERR',e); raise SystemExit
for i in d:
    print('--- #%s [%s] %s'%(i['number'],i['state'],i['title']))
    print(i['body'])
PY
done
