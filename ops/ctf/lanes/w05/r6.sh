#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
G=https://source.keplerops.test
T="Authorization: token fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
echo "== gitea repos search arwc/onboard"
for q in arwc onboarding staff identity employee; do
 echo "--- q=$q"; curl -sS $P -k -m 15 -H "$T" "$G/api/v1/repos/search?q=$q&limit=30" | python3 -c "import sys,json;d=json.load(sys.stdin);print([r['full_name'] for r in d.get('data',[])])" 2>/dev/null
done
echo "== all repos"
curl -sS $P -k -m 15 -H "$T" "$G/api/v1/repos/search?limit=100" | python3 -c "import sys,json;d=json.load(sys.stdin);[print(r['full_name'],r.get('updated_at')) for r in d.get('data',[])]" 2>/dev/null | head -60
echo "== s3 buckets"
curl -sS $P -k -m 15 -i https://objects.keplerops.test/ | head -20
curl -sS $P -k -m 15 "https://objects.keplerops.test/?list-type=2" | head -c 800; echo
