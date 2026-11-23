#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
K="-k -sS -m 25"
H="https://assistant.keplerops.test"
TOK=$(curl $K $P -X POST $H/api/request-token -H 'Content-Type: application/json' \
  -d '{"username":"maya.ranscombe","password":"sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk"}' \
  | python3 -c 'import sys,json;print(json.load(sys.stdin)["token"])')
g(){ echo "== $1"; curl $K $P -H "Authorization: Bearer $TOK" "$H$1" -w "\n[%{http_code}]\n" | head -c 6000; echo; }
for s in fieldlink-operations support-private; do
  g /api/workspace/$s
  g /api/workspace/$s/documents
  g /api/workspace/$s/chats
  g /api/workspace/$s/threads
done
