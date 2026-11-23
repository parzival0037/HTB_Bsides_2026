#!/bin/bash
SSH="ssh -i $HOME/.ssh/keplerops-foothold -o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8 rowan-dev"
$SSH 'A="rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
get(){ curl -sS -m 20 -u "$A" "https://source.keplerops.test/api/v1/repos/fieldkest/$1/contents/$2" | python3 -c "import sys,json,base64;
try:
 d=json.load(sys.stdin); print(base64.b64decode(d[\"content\"]).decode(\"utf-8\",\"replace\"))
except Exception as e: print(\"ERR\",e, sys.stdin.read()[:200])"; }
for f in "fieldlink-connector README.md" "fieldlink-connector docs/report-provider.md" "fieldlink-connector review/FLK-7.4.2.md" "fieldlink-connector tests/test_crr_og2_report.py" "connector-archive README.md" "connector-archive notes/retained-diagnostic.md"; do set -- $f; echo "##### $1/$2"; get "$1" "$2"; done' 2>&1
