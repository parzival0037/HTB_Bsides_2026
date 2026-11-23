P="--socks5-hostname 127.0.0.1:1080 -k -sS --max-time 30"
A=https://assistant.keplerops.test
TOK=$(curl $P -X POST -H 'Content-Type: application/json' -d '{"username":"rowan.ito","password":"fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"}' "$A/api/request-token" | python3 -c 'import sys,json;print(json.load(sys.stdin).get("token",""))')
H="Authorization: Bearer $TOK"
for q in '{"query":"outlet inspection order","topN":10,"similarityThreshold":0}' '{"query":"company history","topN":10,"similarityThreshold":0}'; do
 echo "##### vector-search $q"
 curl $P -H "$H" -H 'Content-Type: application/json' -d "$q" -w '\nCODE=%{http_code}\n' "$A/api/workspace/fieldlink-operations/vector-search" | head -c 5000; echo
done
