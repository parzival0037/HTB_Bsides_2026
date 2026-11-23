#!/bin/bash
SSH="ssh -i $HOME/.ssh/keplerops-foothold -o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8 rowan-dev"
$SSH 'cd ~/repos/connector-archive/connector-archive
for f in README.md notes/retained-diagnostic.md config/diagnostic.conf config/ordinary.conf; do echo "===== $f"; cat "$f"; done
echo "===== ENT head"; head -c 1500 internal/fieldlink/legacy-diagnostics/CRR-OG2/ENT-ARWC-DIAG-0698.json
echo; echo "===== gitea connector repo"
A="rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
curl -sS -m 15 -u "$A" "https://source.keplerops.test/api/v1/repos/fieldkest/fieldlink-connector/git/trees/HEAD?recursive=true&per_page=200" | python3 -c "
import sys,json
d=json.load(sys.stdin)
for t in d.get(\"tree\",[]): print(t[\"path\"])
"' 2>&1 | head -120
