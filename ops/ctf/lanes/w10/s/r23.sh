#!/bin/bash
SSH="ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -i $HOME/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$SSH 'bash -s' <<'INNER'
CA=/home/rowan/.local/share/keplerops/ca.crt
U=rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo
S=https://source.keplerops.test
echo "===== gitea repos search"
for q in relay arwc report district link doc; do
 echo "--- q=$q"; curl -sS -m 15 --cacert $CA -u "$U" "$S/api/v1/repos/search?q=$q&limit=30" | python3 -c 'import json,sys
try:
 d=json.load(sys.stdin); print([r["full_name"] for r in d.get("data",[])])
except Exception as e: print("ERR",e)'
done
echo "===== org repos"
for org in fieldkest arwc; do echo "--- $org"; curl -sS -m 15 --cacert $CA -u "$U" "$S/api/v1/orgs/$org/repos?limit=100" | head -c 3000; echo; done
echo "===== users/repos"
curl -sS -m 15 --cacert $CA -u "$U" "$S/api/v1/user/repos?limit=100" | python3 -c 'import json,sys
try:
 d=json.load(sys.stdin); print([r["full_name"] for r in d])
except Exception as e: print("ERR",e)'
INNER
