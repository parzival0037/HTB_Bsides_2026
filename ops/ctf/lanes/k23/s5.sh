#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
K="-k -sS -m 30"
H="https://assistant.keplerops.test"
TOK=$(curl $K $P -X POST $H/api/request-token -H 'Content-Type: application/json' \
  -d '{"username":"maya.ranscombe","password":"sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk"}' \
  | python3 -c 'import sys,json;print(json.load(sys.stdin)["token"])')
echo "TOKEN OK"
for q in "support reference conversation customer tenant policy authorization document restricted private" "ESC-SUP-2841 ARWC restricted support document" "COMP-JOB-17 completed job ticket" "ATT-DIAG-698 diagnostics attachment" "conversation reference outside current case customer binding"; do
  echo "===== QUERY: $q"
  curl $K $P -X POST "$H/api/workspace/support-private/search" \
    -H "Authorization: Bearer $TOK" -H 'Content-Type: application/json' \
    -d "$(python3 -c 'import json,sys;print(json.dumps({"query":sys.argv[1],"topN":10,"similarityThreshold":0.0}))' "$q")" \
    -w "\n[%{http_code}]\n"
  echo
done
