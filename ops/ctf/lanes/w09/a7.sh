#!/bin/bash
set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=10 rowan-dev"
$S 'set +e
A="rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
CA=$HOME/.local/share/keplerops/ca.crt
echo "########## REPOS"
curl -sS -m 20 --cacert $CA -u "$A" "https://source.keplerops.test/api/v1/repos/search?limit=200&q=" -o /tmp/repos.json -w "%{http_code}\n"
python3 - <<PY
import json
try:
    d=json.load(open("/tmp/repos.json"))
    arr=d.get("data",d if isinstance(d,list) else [])
    print("count",len(arr))
    for r in arr: print(r.get("full_name"),"|",r.get("description"),"|",r.get("updated_at"))
except Exception as e: print("ERR",e)
PY
echo "########## TREES"
python3 - <<PY
import json
d=json.load(open("/tmp/repos.json")); arr=d.get("data",d if isinstance(d,list) else [])
print("\n".join(r.get("full_name","") for r in arr))
PY
echo "########## CONNECTOR BINARY STRINGS"
python3 - <<PY
import re
p="/home/rowan/repos/connector-archive/connector-archive/bin/fieldlink-connector"
d=open(p,"rb").read()
s=set()
for m in re.findall(rb"[ -~]{5,}", d):
    t=m.decode()
    if any(k in t.lower() for k in ("http","/api","arwc","planning","meter","ledger","allocation","process","reading","endpoint","host","service","fieldlink","fieldkest")):
        s.add(t)
for t in sorted(s)[:200]: print(t)
PY
echo DONE_A7
' 2>&1
