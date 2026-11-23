#!/bin/bash
export PX="--socks5-hostname 127.0.0.1:1080"
echo "=== GITEA repos ==="
curl -sS $PX -k "https://source.keplerops.test/api/v1/repos/search?limit=50" -H "Authorization: token fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo" | python3 -c 'import sys,json;d=json.load(sys.stdin);[print(r["full_name"],r.get("description")) for r in d.get("data",[])]' 2>&1
echo
echo "=== rowan-dev ssh test ==="
ssh -o StrictHostKeyChecking=no -o BatchMode=yes -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180 'id; hostname; ls -la ~; ls -la ~/work 2>/dev/null' 2>&1 | head -60
