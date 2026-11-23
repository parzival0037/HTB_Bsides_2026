#!/bin/bash
SSH="ssh -i $HOME/.ssh/keplerops-foothold -o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8 rowan-dev"
$SSH 'A="rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
for repo in fieldkest/connector-archive fieldkest/fieldlink-connector; do
echo "##### $repo"
curl -sS -m 20 -u "$A" "https://source.keplerops.test/api/v1/repos/$repo/git/trees/HEAD?recursive=true&per_page=1000" | python3 -c "import sys,json;d=json.load(sys.stdin);[print(t[\"path\"]) for t in d.get(\"tree\",[])]" 2>&1 | head -200
done' 2>&1
