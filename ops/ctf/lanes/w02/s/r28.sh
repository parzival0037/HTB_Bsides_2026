P="--socks5-hostname 127.0.0.1:1080 -k -sS --max-time 25"
A=https://assistant.keplerops.test
TOK=$(curl $P -X POST -H 'Content-Type: application/json' -d '{"username":"rowan.ito","password":"fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"}' "$A/api/request-token" | python3 -c 'import sys,json;print(json.load(sys.stdin).get("token",""))')
H="Authorization: Bearer $TOK"
Q='{"query":"outlet inspection order supplier job engineering drawing contractor asset maintenance","topN":10,"similarityThreshold":0}'
for p in /api/workspace/fieldlink-operations/vector-search /api/workspace/fieldlink-operations/search /api/workspace/fieldlink-operations/embed; do
 echo "##### $p"; curl $P -H "$H" -H 'Content-Type: application/json' -d "$Q" -i "$A$p" | head -c 4000; echo; done
echo "##### doc fetch attempts"
for p in "/api/workspace/fieldlink-operations/document/1c0fe454-6eec-448b-b2e4-1019457c495b" "/api/workspace/fieldlink-operations/document/1" "/api/document/1c0fe454-6eec-448b-b2e4-1019457c495b" "/api/documents/1c0fe454-6eec-448b-b2e4-1019457c495b"; do
 echo "--- $p"; curl $P -H "$H" -i "$A$p" | head -c 800; echo; done
