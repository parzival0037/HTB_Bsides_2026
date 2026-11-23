#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
TOK=fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo
echo "=== source-tools root ==="
curl -sS $P -k --max-time 20 -i https://source-tools.keplerops.test:8443/ | head -40
echo "=== gitea repos ==="
curl -sS $P -k --max-time 20 -H "Authorization: token $TOK" 'https://source.keplerops.test/api/v1/repos/search?limit=50' | python3 -c "import sys,json; d=json.load(sys.stdin); [print(r['full_name'], r.get('description','')) for r in d.get('data',[])]" 2>&1 | head -50
