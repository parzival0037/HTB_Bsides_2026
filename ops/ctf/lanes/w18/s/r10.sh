#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080 -k -sS --max-time 20"
TOK=fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo
echo "=== gitea repo search"
for q in arwc cairn historian native register scada plc modbus opc; do
 echo "## $q"
 curl $P -H "Authorization: token $TOK" "https://source.keplerops.test/api/v1/repos/search?q=$q&limit=10" | python3 -c "import sys,json
try:
 d=json.load(sys.stdin)
 for r in d.get('data',[]): print(r['full_name'],'|',r.get('description',''))
except Exception as e: print('ERR',e)" 2>&1 | head -20
done
echo "=== all repos"
curl $P -H "Authorization: token $TOK" "https://source.keplerops.test/api/v1/repos/search?limit=100" | python3 -c "import sys,json
d=json.load(sys.stdin)
for r in d.get('data',[]): print(r['full_name'],'|',r.get('description',''))" 2>&1 | head -80
