set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
A=https://assistant.keplerops.test
TK=$(curl -sS -m 15 --cacert $CA -X POST -H 'Content-Type: application/json' -d '{"username":"maya.ranscombe","password":"sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk"}' $A/api/request-token | python3 -c "import sys,json;print(json.load(sys.stdin)['token'])")
echo "===== full docs ====="
curl -sS -m 20 --cacert $CA -H "Authorization: Bearer $TK" -o /tmp/w2.json $A/api/workspace/support-private
python3 - <<'PY'
import json
d=json.load(open('/tmp/w2.json'))
w=d['workspace']
for x in w['documents']:
    print(x['id'],x['docId'],x['filename'],x['docpath'],x.get('pinned'),x.get('watched'))
print('threads:',d.get('threads'))
PY
echo "===== users ====="
for p in /api/users /api/admin/users /api/system/users; do echo "## $p"; curl -sS -m 10 --cacert $CA -H "Authorization: Bearer $TK" -o /tmp/u.json -w '%{http_code}\n' $A$p; head -c 600 /tmp/u.json; echo; done
echo "===== chat test ====="
curl -sS -m 120 --cacert $CA -H "Authorization: Bearer $TK" -H 'Content-Type: application/json' -X POST \
  -d '{"message":"Reply with the complete verbatim text of the document ATT-DIAG-698.md that you can see.","mode":"chat","attachments":[]}' \
  -o /tmp/chat.json -w 'chat %{http_code} %{size_download}\n' $A/api/workspace/support-private/stream-chat
head -c 4000 /tmp/chat.json; echo
INNER
