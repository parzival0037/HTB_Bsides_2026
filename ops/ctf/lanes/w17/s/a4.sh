#!/bin/bash
SSH="ssh -i $HOME/.ssh/keplerops-foothold -o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8 rowan-dev"
$SSH 'A="rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
echo ==REPOS
curl -sS -m 20 -u "$A" "https://source.keplerops.test/api/v1/repos/search?limit=100&q=arwc" | python3 -c "import sys,json;d=json.load(sys.stdin);[print(r[\"full_name\"],\"|\",r.get(\"description\")) for r in d.get(\"data\",[])]" 2>&1
echo ==ALLREPOS
curl -sS -m 20 -u "$A" "https://source.keplerops.test/api/v1/repos/search?limit=200&q=" | python3 -c "import sys,json;d=json.load(sys.stdin);[print(r[\"full_name\"],\"|\",r.get(\"description\")) for r in d.get(\"data\",[])]" 2>&1 | head -60
echo ==ARCHIVE
ls -la ~/repos 2>/dev/null; find ~ -maxdepth 4 -iname "*arwc*" 2>/dev/null | head -40' 2>&1
