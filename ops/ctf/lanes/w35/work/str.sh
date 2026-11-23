#!/bin/bash
R() { ssh -o StrictHostKeyChecking=no -o ConnectTimeout=8 -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180 "$@"; }
echo "=== repos search all ==="
curl -sS --socks5-hostname 127.0.0.1:1080 -k -m 20 -u rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo 'https://source.keplerops.test/api/v1/repos/search?limit=100' | python3 -c 'import sys,json;d=json.load(sys.stdin);[print(r["full_name"]) for r in d.get("data",[])]'
echo "=== strings in connector bin ==="
R 'python3 - <<PYEOF
import re
data=open("/home/rowan/repos/connector-archive/connector-archive/bin/fieldlink-connector","rb").read()
strs=re.findall(rb"[ -~]{5,}",data)
keys=[b"supply",b"quote",b"district",b"catalog",b"procure",b"budget",b"api/",b"arwc",b"route",b"well-known",b"tenant",b"tariff",b"price",b"order"]
for s in strs:
    sl=s.lower()
    if any(k in sl for k in keys):
        print(s.decode("latin1")[:300])
PYEOF'
