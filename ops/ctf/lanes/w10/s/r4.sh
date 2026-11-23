#!/bin/bash
SSH="ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -i $HOME/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
echo "===== support-client.json"
$SSH 'cat /home/rowan/.config/fieldlink/support-client.json 2>&1'
echo "===== grep assistant in home"
$SSH 'grep -rniI "assistant\|anythingllm\|api_key\|apiKey" /home/rowan --exclude-dir=.cache --exclude-dir=.npm 2>/dev/null | head -60'
echo "===== request-token attempts"
$SSH 'bash -s' <<'INNER'
CA=/home/rowan/.local/share/keplerops/ca.crt
A=https://assistant.keplerops.test
try(){ u="$1"; p="$2"; echo "--- $u"; curl -sS -m 10 --cacert $CA -X POST "$A/api/request-token" -H 'Content-Type: application/json' --data "$(python3 -c 'import json,sys; print(json.dumps({"username":sys.argv[1],"password":sys.argv[2]}))' "$u" "$p")" -w '\n[%{http_code}]\n'; }
try maya.ranscombe 'sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk'
try rowan.ito 'sWQa31085FTQekZhHTxUf_9E1marq0ur8WNCKmTtnk'
try rowan.ito 'fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'
try admin 'admin'
try rowan 'rowan'
INNER
echo "===== setup-complete rest"
$SSH 'curl -sS -m 10 --cacert /home/rowan/.local/share/keplerops/ca.crt https://assistant.keplerops.test/api/setup-complete | python3 -m json.tool | tail -60'
