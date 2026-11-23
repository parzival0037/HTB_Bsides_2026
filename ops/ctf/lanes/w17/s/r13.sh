#!/bin/bash
SSH="ssh -i $HOME/.ssh/keplerops-foothold -o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8 rowan-dev"
$SSH 'A="rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
curl -sS -m 15 -u "$A" "https://source.keplerops.test/api/v1/repos/search?limit=100&q=" | python3 -c "
import sys,json
d=json.load(sys.stdin)
for r in d.get(\"data\",[]): print(r[\"full_name\"], r.get(\"description\"))
"' 2>&1 | tail -40
