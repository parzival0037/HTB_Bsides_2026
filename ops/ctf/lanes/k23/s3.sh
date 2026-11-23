#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
K="-k -sS -m 25"
H="https://assistant.keplerops.test"
TOK=$(curl $K $P -X POST $H/api/request-token -H 'Content-Type: application/json' \
  -d '{"username":"maya.ranscombe","password":"sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk"}' \
  | python3 -c 'import sys,json;print(json.load(sys.stdin)["token"])')
echo "TOK=$TOK"
A="-H Authorization:Bearer\ $TOK"
g(){ echo "== $1"; curl $K $P -H "Authorization: Bearer $TOK" "$H$1" -w "\n[%{http_code}]\n" | head -c 4000; echo; }
g /api/workspaces
g /api/system/settings
g /api/users
g /api/admin/workspaces
