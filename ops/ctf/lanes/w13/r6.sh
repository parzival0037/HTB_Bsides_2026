#!/bin/bash
TOK='rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'
P="--socks5-hostname 127.0.0.1:1080 -k --cacert /tmp/ca.crt"
curl -sS -m 15 $P -u "$TOK" 'https://source.keplerops.test/api/v1/repos/search?limit=50' 2>/dev/null | python3 -c 'import json,sys;d=json.load(sys.stdin);[print(r["full_name"], r.get("description")) for r in d.get("data",[])]' 2>&1 | head -60
echo "=== users/orgs ==="
curl -sS -m 15 $P -u "$TOK" 'https://source.keplerops.test/api/v1/orgs?limit=50' 2>/dev/null | head -c 2000
echo; echo "=== well-known source-tools ==="
curl -sS -m 15 $P 'https://source-tools.keplerops.test:8443/.well-known/fieldkest-client' 2>&1 | head -c 2000
