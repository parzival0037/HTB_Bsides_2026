#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080 -k -sS --max-time 20"
U=rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo
for repo in connector-archive fieldlink-connector policy-compiler release-signer-history; do
  echo "############ $repo"
  curl $P -u "$U" "https://source.keplerops.test/api/v1/repos/fieldkest/$repo/git/trees/HEAD?recursive=1&per_page=200" | python3 -c "import sys,json
try:
 d=json.load(sys.stdin)
 for t in d.get('tree',[]): print(t['type'],t['path'])
except Exception as e: print('ERR',e)" 2>&1 | head -100
done
