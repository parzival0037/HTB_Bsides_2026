set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
A=https://assistant.keplerops.test
TOK=$(curl -sS -m 10 --cacert $CA -X POST -H 'Content-Type: application/json' -d '{"username":"rowan.ito","password":"fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"}' "$A/api/request-token" | python3 -c 'import json,sys;print(json.load(sys.stdin)["token"])')
H="Authorization: Bearer $TOK"
for s in support-private rillhaven-support; do
 echo "########## WS $s DETAIL"
 curl -sS -m 10 --cacert $CA -H "$H" "$A/api/workspace/$s" | tee /tmp/ws_$s.json
 echo
 echo "########## WS $s THREADS"
 curl -sS -m 10 --cacert $CA -H "$H" "$A/api/workspace/$s/threads" | tee /tmp/th_$s.json
 echo
 echo "########## WS $s CHATS"
 curl -sS -m 10 --cacert $CA -H "$H" "$A/api/workspace/$s/chats?limit=100" | tee /tmp/ch_$s.json
 echo
done
echo "########## SUMMARIZE"
python3 - <<'PY'
import json,glob
for f in ['/tmp/ws_support-private.json','/tmp/ws_rillhaven-support.json']:
    try:
        d=json.load(open(f))
    except Exception as e:
        print(f,'ERR',e); continue
    w=d.get('workspace',{})
    print('==',f,'name=',w.get('name'),'prompt=',w.get('openAiPrompt'))
    for doc in d.get('documents',[]):
        print(' doc:',doc.get('docpath'),doc.get('metadata'))
for f in glob.glob('/tmp/th_*.json'):
    print('==',f,open(f).read()[:2000])
PY
INNER
echo DONE_MARK_$RANDOM
