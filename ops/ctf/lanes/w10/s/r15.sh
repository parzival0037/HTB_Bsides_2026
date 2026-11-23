#!/bin/bash
SSH="ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -i $HOME/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$SSH 'bash -s' <<'INNER'
CA=/home/rowan/.local/share/keplerops/ca.crt
A=https://assistant.keplerops.test
TOK=$(curl -sS -m 10 --cacert $CA -X POST "$A/api/request-token" -H 'Content-Type: application/json' -d '{"username":"rowan.ito","password":"fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"}' | python3 -c 'import json,sys;print(json.load(sys.stdin)["token"])')
echo "TOK=$TOK"
post(){ p="$1"; d="$2"; echo; echo "### POST $p $d"; curl -sS -m 30 --cacert $CA -X POST -H "Authorization: Bearer $TOK" -H 'Content-Type: application/json' -d "$d" "$A$p" -w '\n[%{http_code}]\n' | head -c 3000; echo; }
post /api/workspace/rillhaven-support/update '{"chatMode":"query"}'
post /api/workspace/fieldlink-operations/update '{"chatMode":"query"}'
echo; echo "### stream rillhaven query after update"
curl -N -sS -m 150 --cacert $CA -X POST -H "Authorization: Bearer $TOK" -H 'Content-Type: application/json' -H 'Accept: text/event-stream' -d '{"message":"List every source document in this workspace and quote the planning excerpt about the current district.","mode":"query","attachments":[],"reset":true}' "$A/api/workspace/rillhaven-support/stream-chat" -w '\n[%{http_code}]\n' | head -c 14000; echo
INNER
