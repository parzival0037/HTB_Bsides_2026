#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
A="-u rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
echo "###### all repos"
curl -sS $P -k -m 25 $A "https://source.keplerops.test/api/v1/repos/search?limit=100" | python3 -c "
import sys,json
d=json.load(sys.stdin)
for r in d['data']: print(r['full_name'], r.get('private'), r.get('description'))
"
for q in arwc onboard starter staff identity hr; do
 echo "--- q=$q"
 curl -sS $P -k -m 20 $A "https://source.keplerops.test/api/v1/repos/search?q=$q&limit=50" | python3 -c "
import sys,json
d=json.load(sys.stdin)
print([r['full_name'] for r in d.get('data',[])])
"
done
