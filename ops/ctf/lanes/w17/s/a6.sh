#!/bin/bash
SSH="ssh -i $HOME/.ssh/keplerops-foothold -o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8 rowan-dev"
$SSH 'A="rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
for f in fieldkest/fieldlink-connector/README.md fieldkest/fieldlink-connector/docs/report-provider.md fieldkest/fieldlink-connector/review/FLK-7.4.2.md fieldkest/fieldlink-connector/tests/test_crr_og2_report.py fieldkest/connector-archive/README.md fieldkest/connector-archive/notes/retained-diagnostic.md one; do
 echo "##### $f"
 [ "$f" = one ] && break
 curl -sS -m 20 -u "$A" "https://source.keplerops.test/api/v1/repos/$f" | python3 -c "import sys,json,base64;d=json.load(sys.stdin);print(base64.b64decode(d[\"content\"]).decode(\"utf-8\",\"replace\"))" 2>&1
done' 2>&1
