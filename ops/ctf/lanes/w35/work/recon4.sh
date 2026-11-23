#!/bin/bash
G='-u rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'
PX='--socks5-hostname 127.0.0.1:1080 -k -m 20'
api() { curl -sS $PX $G "https://source.keplerops.test/api/v1/repos/$1" ; }
echo "=== connector-archive tree ==="
api 'fieldkest/connector-archive/git/trees/main?recursive=1' | python3 -c 'import sys,json;d=json.load(sys.stdin);[print(t["type"],t["path"]) for t in d.get("tree",[])]' 2>/dev/null | head -80
echo "=== release-signer-history tree ==="
api 'fieldkest/release-signer-history/git/trees/main?recursive=1' | python3 -c 'import sys,json;d=json.load(sys.stdin);[print(t["type"],t["path"]) for t in d.get("tree",[])]' 2>/dev/null | head -80
echo "=== fieldlink-connector tree ==="
api 'fieldkest/fieldlink-connector/git/trees/main?recursive=1' | python3 -c 'import sys,json;d=json.load(sys.stdin);[print(t["type"],t["path"]) for t in d.get("tree",[])]' 2>/dev/null | head -100
