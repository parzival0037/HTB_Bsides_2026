#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
B=https://source.keplerops.test
T=fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo
A="-u rowan.ito:$T"
echo "### user repos"; curl -sS $P -k --max-time 15 $A "$B/api/v1/user/repos?limit=50" | python3 -c "import sys,json; d=json.load(sys.stdin); [print(r['full_name'],'|',r.get('description')) for r in d]" 2>&1 | head -40
echo "### search"; curl -sS $P -k --max-time 15 $A "$B/api/v1/repos/search?limit=50" | python3 -c "import sys,json; d=json.load(sys.stdin); [print(r['full_name'],'|',r.get('description')) for r in d.get('data',[])]" 2>&1 | head -60
echo "### fieldlink issues"; curl -sS $P -k --max-time 15 $A "$B/api/v1/repos/fieldkest/fieldlink-connector/issues?state=all&limit=50" | python3 -c "
import sys,json; d=json.load(sys.stdin)
for i in d: print('#%s'%i['number'], i['title'], '|', i['state'])" 2>&1 | head -40
