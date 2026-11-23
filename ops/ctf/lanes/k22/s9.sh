set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
A=https://assistant.keplerops.test
TK=$(curl -sS -m 15 --cacert $CA -X POST -H 'Content-Type: application/json' -d '{"username":"maya.ranscombe","password":"sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk"}' $A/api/request-token | python3 -c "import sys,json;print(json.load(sys.stdin)['token'])")
echo "===== sync chat workspace2 ====="
curl -sS -m 180 --cacert $CA -H "Authorization: Bearer $TK" -H 'Content-Type: application/json' -X POST \
  -d '{"message":"What documents do you have about the ARWC support case? Quote ATT-DIAG-698.md verbatim.","mode":"chat","attachments":[]}' \
  -o /tmp/c2.json -w 'chat %{http_code} %{size_download}\n' $A/api/workspace/support-private/chat
head -c 5000 /tmp/c2.json; echo
echo "===== threads after ====="
curl -sS -m 20 --cacert $CA -H "Authorization: Bearer $TK" -o /tmp/th.json $A/api/workspace/support-private/threads
head -c 2000 /tmp/th.json; echo
echo "===== workspace1 sync chat ====="
curl -sS -m 180 --cacert $CA -H "Authorization: Bearer $TK" -H 'Content-Type: application/json' -X POST \
  -d '{"message":"List the documents you can see and quote working-guide.md verbatim.","mode":"chat","attachments":[]}' \
  -o /tmp/c1.json -w 'chat %{http_code} %{size_download}\n' $A/api/workspace/fieldlink-operations/chat
head -c 4000 /tmp/c1.json; echo
INNER
