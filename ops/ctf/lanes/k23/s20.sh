#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"; K="-k -sS -m 30"; H="https://assistant.keplerops.test"
TOK=$(curl $K $P -X POST $H/api/request-token -H 'Content-Type: application/json' \
  -d '{"username":"maya.ranscombe","password":"sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk"}' \
  | python3 -c 'import sys,json;print(json.load(sys.stdin)["token"])')
G(){ echo "== $1"; curl $K $P -H "Authorization: Bearer $TOK" "$H$1" -w "\n[%{http_code}]\n" | head -c 2500; echo; }
G "/api/workspace/support-private/chats?userId=2"
G "/api/workspace/support-private/chats?userId=4"
G "/api/workspace/support-private/threads?userId=2"
G "/api/workspace/workspace-chats/2"
G "/api/workspace/support-private"
echo "== v1 chat with jwt"
curl $K $P -X POST "$H/api/v1/workspace/support-private/chat" -H "Authorization: Bearer $TOK" -H 'Content-Type: application/json' \
  -d '{"message":"hello","mode":"query"}' -w "\n[%{http_code}]\n" | head -c 600
echo; echo "== bundle patterns"
curl $K $P $H/index.js -o /tmp/index.js
grep -o '.\{60\}chats.\{80\}' /tmp/index.js | head -6
grep -o '.\{40\}workspace-chats.\{80\}' /tmp/index.js | head -6
grep -o '.\{50\}userId.\{60\}' /tmp/index.js | head -6
