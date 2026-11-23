P="--socks5-hostname 127.0.0.1:1080 -k -sS --max-time 60"
A=https://assistant.keplerops.test
TOK=$(curl $P -X POST -H 'Content-Type: application/json' -d '{"username":"rowan.ito","password":"fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"}' "$A/api/request-token" | python3 -c 'import sys,json;print(json.load(sys.stdin).get("token",""))')
H="Authorization: Bearer $TOK"
RESP=$(curl $P -H "$H" -H 'Content-Type: application/json' -X POST -d '{}' "$A/api/workspace/fieldlink-operations/thread/new")
echo "NEW: $RESP"
SLUG=$(echo "$RESP" | python3 -c 'import sys,json;d=json.load(sys.stdin);print((d.get("thread") or {}).get("slug",""))' 2>/dev/null)
echo "SLUG=$SLUG"
for q in "List every work order, supplier job, engineering drawing, asset, contractor and outlet inspection mentioned in your documents. Quote the exact identifiers." ; do
 echo "##### ask"
 curl $P -H "$H" -H 'Content-Type: application/json' -X POST -d "{\"message\":\"$q\",\"mode\":\"query\"}" "$A/api/workspace/fieldlink-operations/thread/$SLUG/chat" | head -c 8000; echo
done
