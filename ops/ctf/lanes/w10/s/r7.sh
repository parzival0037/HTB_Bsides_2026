#!/bin/bash
SSH="ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -i $HOME/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$SSH 'bash -s' <<'INNER'
CA=/home/rowan/.local/share/keplerops/ca.crt
A=https://assistant.keplerops.test
TOK=$(curl -sS -m 10 --cacert $CA -X POST "$A/api/request-token" -H 'Content-Type: application/json' -d '{"username":"rowan.ito","password":"fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"}' | python3 -c 'import json,sys;print(json.load(sys.stdin)["token"])')
echo "TOKJWT=$TOK"
g(){ p="$1"; echo; echo "########## GET $p"; curl -sS -m 20 --cacert $CA -H "Authorization: Bearer $TOK" "$A$p" -w '\n[%{http_code}]\n' | head -c 5000; echo; }
g "/api/document/1"
g "/api/document/1c0fe454-6eec-448b-b2e4-1019457c495b"
g "/api/workspace/fieldlink-operations/document/1"
g "/api/workspace/fieldlink-operations/documents/1"
g "/api/workspace/fieldlink-operations/document/1c0fe454-6eec-448b-b2e4-1019457c495b"
g "/api/workspaces/fieldlink-operations/documents"
g "/api/workspace/fieldlink-operations/query"
echo; echo "########## POST chat fieldlink-operations"
curl -sS -m 90 --cacert $CA -X POST -H "Authorization: Bearer $TOK" -H 'Content-Type: application/json' \
 -d '{"message":"List every district mentioned in the company documents and the exact source documents that mention them. Quote the source titles verbatim.","mode":"query","attachments":[],"reset":true}' \
 "$A/api/workspace/fieldlink-operations/chat" -w '\n[%{http_code}]\n' | head -c 8000
echo; echo "########## POST chat rillhaven-support"
curl -sS -m 90 --cacert $CA -X POST -H "Authorization: Bearer $TOK" -H 'Content-Type: application/json' \
 -d '{"message":"What is this workspace for? List every source document and quote the planning excerpt about the current district.","mode":"query","attachments":[],"reset":true}' \
 "$A/api/workspace/rillhaven-support/chat" -w '\n[%{http_code}]\n' | head -c 8000
echo
INNER
