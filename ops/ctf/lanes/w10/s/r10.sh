#!/bin/bash
SSH="ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -i $HOME/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$SSH 'bash -s' <<'INNER'
CA=/home/rowan/.local/share/keplerops/ca.crt
A=https://assistant.keplerops.test
TOK=$(curl -sS -m 10 --cacert $CA -X POST "$A/api/request-token" -H 'Content-Type: application/json' -d '{"username":"rowan.ito","password":"fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"}' | python3 -c 'import json,sys;print(json.load(sys.stdin)["token"])')
echo "TOK=$TOK"
chat(){ s="$1"; msg="$2"; echo; echo "########## $s :: $msg"; curl -N -sS -m 120 --cacert $CA -X POST -H "Authorization: Bearer $TOK" -H 'Content-Type: application/json' -H 'Accept: text/event-stream' -d "$(python3 -c 'import json,sys; print(json.dumps({"message":sys.argv[1],"attachments":[],"reasoningEffort":None}))' "$msg")" "$A/api/workspace/$s/stream-chat" -w '\n[%{http_code}]\n' | head -c 12000; echo; }
chat fieldlink-operations "List every district mentioned in the company documents and the exact source documents that mention them. Quote source titles verbatim."
chat rillhaven-support "List every source document in this workspace and quote the planning excerpt about the current district."
INNER
