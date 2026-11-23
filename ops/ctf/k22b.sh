set +e
P="curl -sS -m 8 --socks5-hostname 127.0.0.1:1080 -k"
TOK=$(curl -sS -m 8 --socks5-hostname 127.0.0.1:1080 -k -X POST -H 'Content-Type: application/json' -d '{"username":"rowan.ito","password":"fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"}' https://assistant.keplerops.test/api/request-token | python3 -c "import sys,json;print(json.load(sys.stdin).get('token',''))")
A="Authorization: Bearer $TOK"
for p in /api/contexts/ctx-support-private-v4 /api/contexts/ctx-support-private-v4/documents /api/documents /api/workspace/support-private /api/workspaces/support-private/documents /api/contexts/ctx-rill-support-v3; do
  printf '%-52s ' "$p"; $P -H "$A" -o /tmp/k -w '%{http_code} ' "https://assistant.keplerops.test$p"; head -c 240 /tmp/k | tr '\n' ' '; echo
done
