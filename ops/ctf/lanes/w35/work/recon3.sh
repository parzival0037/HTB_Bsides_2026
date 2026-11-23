#!/bin/bash
R() { ssh -o StrictHostKeyChecking=no -o ConnectTimeout=8 -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180 "$@"; }
echo "=== rowan-dev work dirs ==="
R 'ls -la ~/work ~/ 2>/dev/null; find ~/work -maxdepth 2 -type d 2>/dev/null | head -50'
echo "=== gitea orgs/repos ==="
G='-u rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'
curl -sS --socks5-hostname 127.0.0.1:1080 -k -m 15 $G 'https://source.keplerops.test/api/v1/repos/search?q=arwc&limit=50' | head -c 4000
echo
echo "=== gitea all repos fieldkest ==="
curl -sS --socks5-hostname 127.0.0.1:1080 -k -m 15 $G 'https://source.keplerops.test/api/v1/orgs/fieldkest/repos?limit=50' | python3 -c 'import sys,json;d=json.load(sys.stdin);[print(r["full_name"]) for r in d]' 2>/dev/null
