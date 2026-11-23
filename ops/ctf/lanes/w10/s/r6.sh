#!/bin/bash
SSH="ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -i $HOME/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$SSH 'bash -s' <<'INNER'
CA=/home/rowan/.local/share/keplerops/ca.crt
A=https://assistant.keplerops.test
TOK=$(curl -sS -m 10 --cacert $CA -X POST "$A/api/request-token" -H 'Content-Type: application/json' -d '{"username":"rowan.ito","password":"fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"}' | python3 -c 'import json,sys;print(json.load(sys.stdin)["token"])')
echo "TOKJWT=$TOK"
g(){ p="$1"; echo; echo "########## GET $p"; curl -sS -m 20 --cacert $CA -H "Authorization: Bearer $TOK" "$A$p" -w '\n[%{http_code}]\n' | head -c 8000; echo; }
for s in fieldlink-operations support-private rillhaven-support; do
  g "/api/workspace/$s"
  g "/api/workspace/$s/threads"
  g "/api/workspace/$s/documents"
  g "/api/workspace/$s/pinned-documents"
done
g "/api/workspace/fieldlink-operations/threads"
INNER
