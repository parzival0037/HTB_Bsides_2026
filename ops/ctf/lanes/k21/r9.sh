set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
A=https://assistant.keplerops.test
TOK=$(curl -sS -m 10 --cacert $CA -X POST -H 'Content-Type: application/json' -d '{"username":"rowan.ito","password":"fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"}' "$A/api/request-token" | python3 -c 'import json,sys;print(json.load(sys.stdin)["token"])')
H="Authorization: Bearer $TOK"
echo "########## ROUTE PROBES"
for p in /api/workspace/support-private/chat /api/workspace/support-private/stream-chat /api/v1/workspace/support-private/chat /api/workspace/support-private/query /api/workspace/support-private/search /api/workspace/support-private/vector-search; do
 echo "--- $p"
 curl -sS -m 20 --cacert $CA -H "$H" -H 'Content-Type: application/json' -X POST -d '{"message":"hello","mode":"chat","attachments":[]}' -i "$A$p" | head -c 400
 echo
done
echo "########## FRONTEND JS ROUTES"
curl -sS -m 10 --cacert $CA "$A/" | grep -oE 'src="[^"]+\.js"' | head
INNER
echo DONE_MARK_$RANDOM
