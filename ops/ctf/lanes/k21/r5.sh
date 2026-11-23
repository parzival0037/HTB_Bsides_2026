set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
A=https://assistant.keplerops.test
login(){ curl -sS -m 10 --cacert $CA -X POST -H 'Content-Type: application/json' -d "{\"username\":\"$1\",\"password\":\"$2\"}" "$A/api/request-token"; }
TOK=$(login rowan.ito fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo | python3 -c 'import json,sys;print(json.load(sys.stdin)["token"])')
echo "TOKLEN ${#TOK}"
H="Authorization: Bearer $TOK"
echo "########## WORKSPACES"
curl -sS -m 10 --cacert $CA -H "$H" "$A/api/workspaces" | tee /tmp/ws.json
echo
echo "########## WORKSPACE DETAIL FIELDLLINK-OPS"
for s in fieldlink-operations; do
 echo "--- ws $s"; curl -sS -m 10 --cacert $CA -H "$H" "$A/api/workspace/$s" | tee /tmp/ws_$s.json
 echo; echo "--- threads"; curl -sS -m 10 --cacert $CA -H "$H" "$A/api/workspace/$s/threads"; echo
 echo "--- chats"; curl -sS -m 10 --cacert $CA -H "$H" "$A/api/workspace/$s/chats?limit=50"; echo
done
echo "########## SLUGS FROM LIST"
python3 - <<'PY'
import json
try:
    d=json.load(open('/tmp/ws.json'))
    for w in d.get('workspaces',[]):
        print(w.get('slug'), '|', w.get('name'))
except Exception as e: print('ERR',e)
PY
echo "########## ADMIN (rowan)"
for p in /api/admin/workspaces /api/admin/users /api/admin/invites /api/admin/system-preferences /api/admin/system-vectors; do
 echo "--- $p"; curl -sS -m 8 --cacert $CA -H "$H" -i "$A$p" | head -c 600; echo
done
INNER
echo DONE_MARK_$RANDOM
