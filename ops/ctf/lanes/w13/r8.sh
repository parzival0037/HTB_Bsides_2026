#!/bin/bash
TOK='rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'
P="--socks5-hostname 127.0.0.1:1080 -k"
for repo in fieldlink-connector connector-archive policy-compiler release-signer-history; do
echo "=== issues $repo ==="
curl -sS -m 15 $P -u "$TOK" "https://source.keplerops.test/api/v1/repos/fieldkest/$repo/issues?state=all&limit=50" 2>/dev/null | python3 -c '
import json,sys
try: d=json.load(sys.stdin)
except: sys.exit()
for i in d:
    print(i["number"], i["state"], i["title"])
    print("   ", (i.get("body") or "")[:600].replace("\n"," "))
' 2>&1
done
