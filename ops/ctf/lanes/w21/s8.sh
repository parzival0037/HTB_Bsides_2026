#!/bin/bash
SSH="ssh -i $HOME/.ssh/keplerops-foothold -o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8 rowan-dev"
$SSH 'DT=fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo
ST=fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b
A=https://assistant.keplerops.test
echo == assistant token
TOK=$(curl -sS -m 15 -k -X POST -H "Content-Type: application/json" -d "{\"username\":\"rowan.ito\",\"password\":\"$DT\"}" "$A/api/request-token" | python3 -c "import sys,json;print(json.load(sys.stdin).get(\"token\",\"\"))")
echo len=${#TOK}
echo == workspaces
curl -sS -m 20 -k -H "Authorization: Bearer $TOK" "$A/api/workspaces" -o /tmp/ws.json -w "%{http_code}\n"
python3 - <<PY
import json
d=json.load(open("/tmp/ws.json"))
ws=d if isinstance(d,list) else d.get("workspaces",d)
for w in ws:
    if isinstance(w,dict): print(w.get("id"),w.get("slug"),w.get("name"))
PY
echo == admin workspaces
for p in /api/admin/workspaces /api/admin/workspace-users; do printf "%s -> " $p; curl -sS -m 15 -k -o /tmp/o -w "%{http_code} " -H "Authorization: Bearer $TOK" "$A$p"; head -c 600 /tmp/o; echo; done
echo == workboard
WB=https://workboard.keplerops.test
echo "-- projects"
curl -sS -m 15 -k -u rowan.ito:$DT "$WB/api/v1/projects" | head -c 1500; echo
echo "-- /api/v1/tasks"
curl -sS -m 15 -k -u rowan.ito:$DT "$WB/api/v1/tasks?per_page=5" | head -c 800; echo
' 2>&1
