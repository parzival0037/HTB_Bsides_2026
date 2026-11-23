#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080 -k -sS -m 15"
A=https://assistant.keplerops.test
TOK=$(curl $P -X POST "$A/api/request-token" -H 'Content-Type: application/json' -d '{"username":"rowan.ito","password":"fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"}' | python3 -c 'import json,sys;print(json.load(sys.stdin)["token"])')
echo "TOK=${TOK:0:20}"
g(){ echo; echo "##### $1"; curl $P -H "Authorization: Bearer $TOK" "$A$1" -o /tmp/r.$$ -w '%{http_code}\n'; head -c 2500 /tmp/r.$$; echo; }
g /api/workspaces
g /api/v1/workspaces
g /api/v1/admin/workspaces
g /api/system/settings
g /api/v1/system/settings
g /api/users
g /api/admin/users
echo "===== workspace slug guess"
for s in reports report district-reports district arwc-reports arwc planning districts fieldlink-reports report-assistant cairn-reach fieldlink-operations support-private rillhaven-support; do
  code=$(curl $P -H "Authorization: Bearer $TOK" "$A/api/workspace/$s" -o /tmp/w.$$ -w '%{http_code}')
  echo "$s -> $code $(head -c 150 /tmp/w.$$ | tr -d '\n')"
done
rm -f /tmp/r.$$ /tmp/w.$$
