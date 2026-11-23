#!/bin/bash
AUTH='rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'
P='--socks5-hostname 127.0.0.1:1080'
echo "== gitea repos search =="
for q in relay customer arwc connector edge fieldkest; do
  echo "--- q=$q"
  curl -sS -m 20 $P -k -u "$AUTH" "https://source.keplerops.test/api/v1/repos/search?q=$q&limit=50" 2>&1 | python3 -c "import sys,json;d=json.load(sys.stdin);print([ (r['full_name'],r.get('description')) for r in d.get('data',[])])" 2>&1 | head -5
done
echo "== gitea orgs =="
curl -sS -m 20 $P -k -u "$AUTH" "https://source.keplerops.test/api/v1/orgs" 2>&1 | head -c 1000
echo
echo "== rowan repos ls =="
ssh -o StrictHostKeyChecking=no -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180 'ls -la ~/repos; git -C ~/work/fieldlink-connector remote -v; ls ~/work/fieldlink-connector; find ~/work/fieldlink-connector -name "*.md" | head -30' 2>&1
