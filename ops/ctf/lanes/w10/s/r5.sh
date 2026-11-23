#!/bin/bash
SSH="ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -i $HOME/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$SSH 'bash -s' <<'INNER'
CA=/home/rowan/.local/share/keplerops/ca.crt
A=https://assistant.keplerops.test
TOK=$(curl -sS -m 10 --cacert $CA -X POST "$A/api/request-token" -H 'Content-Type: application/json' -d '{"username":"rowan.ito","password":"fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"}' | python3 -c 'import json,sys;print(json.load(sys.stdin)["token"])')
echo "TOK=${TOK:0:40}..."
g(){ p="$1"; echo "### GET $p"; curl -sS -m 15 --cacert $CA -H "Authorization: Bearer $TOK" "$A$p" -w '\n[%{http_code}]\n' | head -c 6000; echo; }
p(){ q="$1"; d="$2"; echo "### POST $q"; curl -sS -m 15 --cacert $CA -X POST -H "Authorization: Bearer $TOK" -H 'Content-Type: application/json' -d "$d" "$A$q" -w '\n[%{http_code}]\n' | head -c 4000; echo; }
g /api/workspaces
g /api/system/settings
g /api/users
g /api/admin/users
g /api/v1/workspaces
g /api/workspace
INNER
