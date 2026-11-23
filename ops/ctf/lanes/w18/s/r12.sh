#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080 -k -sS --max-time 20"
U=rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo
echo "=== gitea basic auth user"
curl $P -u "$U" -w '\n[%{http_code}]\n' https://source.keplerops.test/api/v1/user | head -c 500
echo
echo "=== repo search basic"
curl $P -u "$U" 'https://source.keplerops.test/api/v1/repos/search?limit=100' | python3 -c "import sys,json
try:
 d=json.load(sys.stdin); print('count',d.get('ok'),len(d.get('data',[])))
 for r in d.get('data',[]): print(r['full_name'],'|',r.get('description',''))
except Exception as e: print('ERR',e)" 2>&1 | head -60
echo "=== orgs fieldkest repos"
curl $P -u "$U" 'https://source.keplerops.test/api/v1/orgs/fieldkest/repos?limit=100' | python3 -c "import sys,json
try:
 d=json.load(sys.stdin)
 for r in d: print(r['full_name'],'|',r.get('description',''))
except Exception as e: print('ERR',e)" 2>&1 | head -60
