P="--socks5-hostname 127.0.0.1:1080 -k -sS --max-time 20"
A=https://assistant.keplerops.test
TOK=$(curl $P -X POST -H 'Content-Type: application/json' -d '{"username":"rowan.ito","password":"fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"}' "$A/api/request-token" | python3 -c 'import sys,json;print(json.load(sys.stdin).get("token",""))')
echo "TOKLEN=${#TOK}"
H="Authorization: Bearer $TOK"
for p in /api/workspaces /api/workspace/fieldlink-operations /api/workspace/fieldlink-operations/documents /api/workspace/support-private /api/workspace/rill-support; do
 echo "##### $p"; curl $P -H "$H" -i "$A$p" | head -c 3000; echo; done
