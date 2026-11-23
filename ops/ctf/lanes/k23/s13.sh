#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
K="-k -sS -m 30"
H="https://assistant.keplerops.test"
TOK=$(curl $K $P -X POST $H/api/request-token -H 'Content-Type: application/json' \
  -d '{"username":"maya.ranscombe","password":"sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk"}' \
  | python3 -c 'import sys,json;print(json.load(sys.stdin)["token"])')
G(){ echo "== $1"; curl $K $P -H "Authorization: Bearer $TOK" "$H$1" -w "\n[%{http_code}]\n" | head -c 6000; echo; }
G /api/workspace/support-private/chats
G /api/workspace/support-private/threads
G /api/workspace/fieldlink-operations/chats
echo "== support well-known + guesses"
for u in /.well-known/fieldkest-client /.well-known/api-catalog /api/v1/tickets /v1/tickets /tickets/SUP-2841 /api/tickets/SUP-2841 /conversations /api/conversations /docs /metrics; do
  echo "-- $u"
  curl $K $P -H "Authorization: Bearer fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b" "https://support.keplerops.test:8443$u" -w "\n[%{http_code}]\n" | head -c 500; echo
done
