#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"; K="-k -sS -m 30"; H="https://assistant.keplerops.test"
CJ=/tmp/acj.txt; rm -f $CJ
echo "== headers for /api/config"
curl $K $P -c $CJ -b $CJ -D - -o /tmp/cfg.json "$H/api/config"
echo; echo "== headers for /api/contexts"
curl $K $P -c $CJ -b $CJ -D - -o /tmp/ctx.json "$H/api/contexts"
echo; echo "== cookies"; cat $CJ
echo "== after cookie, conversation"
curl $K $P -b $CJ "$H/api/conversations/CONV-SUP-2841-19" -w "\n[%{http_code}]\n" | head -c 1500
echo; echo "== POST answers empty"
curl $K $P -b $CJ -X POST "$H/api/answers" -H 'Content-Type: application/json' -d '{}' -w "\n[%{http_code}]\n" | head -c 1500
echo; echo "== session probes"
for u in /api/session /session /api/login; do echo "-- $u"; curl $K $P -b $CJ "$H$u" -w "\n[%{http_code}]\n" | head -c 300; echo; done
echo "== root set-cookie"
curl $K $P -D - -o /dev/null "$H/" | head -20
