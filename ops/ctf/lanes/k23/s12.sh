#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
K="-k -sS -m 30"
H="https://assistant.keplerops.test"
TOK=$(curl $K $P -X POST $H/api/request-token -H 'Content-Type: application/json' \
  -d '{"username":"maya.ranscombe","password":"sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk"}' \
  | python3 -c 'import sys,json;print(json.load(sys.stdin)["token"])')
echo "== update workspace"
curl $K $P -X POST "$H/api/workspace/support-private/update" -H "Authorization: Bearer $TOK" -H 'Content-Type: application/json' \
  -d '{"chatMode":"chat","openAiPrompt":"test"}' -w "\n[%{http_code}]\n" | head -c 500
echo; echo "== stream chat hello mode query"
curl $K $P -X POST "$H/api/workspace/fieldlink-operations/stream-chat" -H "Authorization: Bearer $TOK" -H 'Content-Type: application/json' \
  -d '{"message":"hello","mode":"query"}' --max-time 60 | head -c 2000
echo; echo "== support root"
curl $K $P https://support.keplerops.test/ -o /tmp/sup.html -w "root %{http_code} %{size_download}\n"
head -c 400 /tmp/sup.html; echo
curl $K $P https://support.keplerops.test/scp/ -o /tmp/scp.html -w "scp %{http_code} %{size_download}\n"
grep -o 'name="[a-z_]*"' /tmp/scp.html | sort -u | head -20
echo "== support 8443"
for u in / /openapi.json /api /tickets /api/tickets /health; do
  echo "-- $u"
  curl $K $P -H "Authorization: Bearer fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b" "https://support.keplerops.test:8443$u" -w "\n[%{http_code}]\n" | head -c 700; echo
done
