#!/bin/bash
SSH="ssh -i $HOME/.ssh/keplerops-foothold -o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8 rowan-dev"
$SSH 'T=fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo
B=https://source.keplerops.test
echo == repos; curl -sS -m 20 -u rowan.ito:$T "$B/api/v1/repos/search?limit=50&q=" | python3 -c "import sys,json;d=json.load(sys.stdin);[print(r[\"full_name\"],r.get(\"description\")) for r in d.get(\"data\",[])]"
echo == orgs; curl -sS -m 20 -u rowan.ito:$T "$B/api/v1/admin/orgs?limit=50" | head -c 800; echo
echo == users; curl -sS -m 20 -u rowan.ito:$T "$B/api/v1/admin/users?limit=50" | python3 -c "import sys,json;d=json.load(sys.stdin);[print(u[\"login\"],u.get(\"is_admin\")) for u in d]" 2>/dev/null
echo == arwc repos search
for q in arwc cairn openplc plc controller fuxa project commissioning note; do
 echo "-- $q"; curl -sS -m 15 -u rowan.ito:$T "$B/api/v1/repos/search?q=$q&limit=20" | python3 -c "import sys,json;d=json.load(sys.stdin);[print(\" \",r[\"full_name\"],r.get(\"description\")) for r in d.get(\"data\",[])]" 2>/dev/null
done
echo == resolv; cat /etc/resolv.conf
' 2>&1
