set +e
P="curl -sS -m 10 --socks5-hostname 127.0.0.1:1080 -k"
TOK=$($P -X POST -H 'Content-Type: application/json' -d '{"username":"rowan.ito","password":"fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"}' https://assistant.keplerops.test/api/request-token | python3 -c "import sys,json;print(json.load(sys.stdin).get('token',''))" 2>/dev/null)
echo "token: ${TOK:0:20}..."
for p in /api/contexts /api/config /api/workspaces; do
  echo "=== $p"; $P -H "Authorization: Bearer $TOK" "https://assistant.keplerops.test$p" | head -c 600; echo
done
