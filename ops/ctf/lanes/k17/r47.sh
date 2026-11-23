set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
A=https://assistant.keplerops.test
TOK=$(curl -sSk -m 10 --cacert $CA -X POST -H 'Content-Type: application/json' -d '{"username":"rowan.ito","password":"fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"}' "$A/api/request-token" | python3 -c 'import json,sys;print(json.load(sys.stdin).get("token",""))')
H="Authorization: Bearer $TOK"
echo "TOKLEN=${#TOK}"
for p in /api/workspaces /api/workspace /api/workspaces/support-private /api/workspace/support-private/documents /api/workspace/rill-support /api/workspace/ctx-support-private-v4 /api/documents /api/system/workspaces /api/admin/workspaces; do
 echo "######## GET $p"
 curl -sSk -m 10 --cacert $CA -H "$H" -w '\n[%{http_code}]\n' "$A$p" | head -c 2500; echo
done
echo "######## full support-private doc list"
curl -sSk -m 10 --cacert $CA -H "$H" "$A/api/workspace/support-private" > /tmp/wsp.json
python3 - <<'PY'
import json
d=json.load(open('/tmp/wsp.json'))
for doc in d.get('workspace',{}).get('documents',[]):
    print(doc.get('id'), doc.get('filename'), '|', doc.get('docpath'))
PY
echo "######## document content probes"
for u in "/api/workspace/support-private/document/ESC-SUP-2841-R3.md" "/api/workspace/support-private/documents/ESC-SUP-2841-R3.md" "/api/document/ESC-SUP-2841-R3.md" "/api/workspace/support-private/ESC-SUP-2841-R3.md"; do
 echo "--- $u"
 curl -sSk -m 10 --cacert $CA -H "$H" -w '\n[%{http_code}]\n' "$A$u" | head -c 800; echo
done
INNER
echo DONE_R47
