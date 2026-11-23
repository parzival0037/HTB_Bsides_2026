#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080 -k -sS -m 15"
A=https://assistant.keplerops.test
TOK=$(curl $P -X POST "$A/api/request-token" -H 'Content-Type: application/json' -d '{"username":"rowan.ito","password":"fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"}' | python3 -c 'import json,sys;print(json.load(sys.stdin)["token"])')
echo "== token tests for /api/v1/workspaces"
for t in "fk_workload_fixture_7nNUHpIQRCb5s2SLo7lb0sJH9LXByeMK" "fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b" "fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo" "$TOK"; do
  for h in "Authorization: Bearer $t" "Authorization: api_key $t" "X-Api-Key: $t"; do
    code=$(curl $P -H "$h" "$A/api/v1/workspaces" -o /tmp/t.$$ -w '%{http_code}')
    echo "$h -> $code $(head -c 80 /tmp/t.$$ | tr -d '\n')"
  done
done
rm -f /tmp/t.$$
echo "== workspace slug guesses with rowan jwt"
for s in cedar-run riverbend north-quay marshgate district-reports districts reports report-assistant arwc-reports fieldlink-reports planning; do
  code=$(curl $P -H "Authorization: Bearer $TOK" "$A/api/workspace/$s" -o /tmp/w.$$ -w '%{http_code}')
  echo "$s -> $code $(head -c 100 /tmp/w.$$ | tr -d '\n')"
done
rm -f /tmp/w.$$
echo "== workspace id/browse endpoints"
for u in "/api/workspace" "/api/workspace/" "/api/workspaces/1" "/api/workspaces/2" "/api/workspaces/3" "/api/workspace/search?q=district" "/api/workspace/fieldlink-operations/search?q=district" "/api/workspace/fieldlink-operations/sources" "/api/workspace/fieldlink-operations/chats"; do
  code=$(curl $P -H "Authorization: Bearer $TOK" "$A$u" -o /tmp/w.$$ -w '%{http_code}')
  echo "$u -> $code $(head -c 120 /tmp/w.$$ | tr -d '\n')"
done
rm -f /tmp/w.$$
