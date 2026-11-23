#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"; K="-k -sS -m 30"; H="https://assistant.keplerops.test"
TOK=$(curl $K $P -X POST $H/api/request-token -H 'Content-Type: application/json' \
  -d '{"username":"maya.ranscombe","password":"sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk"}' \
  | python3 -c 'import sys,json;print(json.load(sys.stdin)["token"])')
for u in /api/system/footer-data /api/system/multi-user-mode /api/system/accepted-document-types /api/system/default-system-prompt /api/system/support-email /api/system/custom-models /api/utils/metrics /api/system/document-processing-status /api/system/prompt-variables /api/system/user /api/system/check-token /api/system/theme-palettes /api/system/event-logs; do
  echo "-- $u"
  curl $K $P -H "Authorization: Bearer $TOK" "$H$u" -w "\n[%{http_code}]\n" | head -c 700; echo
done
echo "== unauthenticated workspace"
curl $K $P "$H/api/workspace/support-private" -w "\n[%{http_code}]\n" | head -c 300
