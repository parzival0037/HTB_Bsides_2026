set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
A=https://assistant.keplerops.test
login(){ curl -sS -m 10 --cacert $CA -X POST -H 'Content-Type: application/json' -d "{\"username\":\"$1\",\"password\":\"$2\"}" "$A/api/request-token" | python3 -c 'import json,sys;d=json.load(sys.stdin);print(d.get("token") or "NONE")'; }
for cred in "maya.ranscombe:sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk" "rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"; do
 U=${cred%%:*}; P=${cred#*:}
 TOK=$(login "$U" "$P")
 H="Authorization: Bearer $TOK"
 echo "########## USER $U tokenlen ${#TOK}"
 for s in fieldlink-operations support-private rillhaven-support; do
  echo "--- $s threads"; curl -sS -m 10 --cacert $CA -H "$H" "$A/api/workspace/$s/threads"; echo
  echo "--- $s chats"; curl -sS -m 10 --cacert $CA -H "$H" "$A/api/workspace/$s/chats?limit=100" | head -c 4000; echo
 done
 echo "--- admin/users"; curl -sS -m 8 --cacert $CA -H "$H" -i "$A/api/admin/users" | head -c 500; echo
done
echo "########## S3 BUCKETS"
export AWS_PAGER=""
aws --endpoint-url https://objects.keplerops.test s3 ls 2>&1 | head -20
echo "########## S3 fieldlink-exports"
aws --endpoint-url https://objects.keplerops.test s3 ls s3://fieldlink-exports 2>&1 | head -20
INNER
echo DONE_MARK_$RANDOM
