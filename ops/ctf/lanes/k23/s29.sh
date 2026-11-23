#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"; K="-k -sS -m 30"; H="https://assistant.keplerops.test"
TOK=$(curl $K $P -X POST $H/api/request-token -H 'Content-Type: application/json' \
  -d '{"username":"maya.ranscombe","password":"sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk"}' \
  | python3 -c 'import sys,json;print(json.load(sys.stdin)["token"])')
for u in /api/agent-skills/filesystem-agent/is-available /api/agent-skills/create-files-agent/is-available /api/agent-skills/image-generation/is-available /api/workspace/support-private/llm-capabilities /api/workspaces /api/system/api-keys; do
 echo "-- $u"; curl $K $P -H "Authorization: Bearer $TOK" "$H$u" -w "\n[%{http_code}]\n" | head -c 1200; echo
done
