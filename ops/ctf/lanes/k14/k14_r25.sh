set +e
ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=8 rowan-dev 'bash -s' <<'RSH'
set +e
export AWS_PAGER=""
CA=$HOME/.local/share/keplerops/ca.crt
B=https://cloud-api.keplerops.test
K=https://cloud-api.keplerops.test:6443
U="rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
WT=$(curl -sSk -m 10 -u "$U" -X POST -H 'Content-Type: application/json' -d '{}' "$B/api/workspaces/current/token-exchange" | python3 -c 'import sys,json;print(json.load(sys.stdin).get("access_token",""))')
echo "WT_LEN ${#WT}"
R=$(curl -sSk -m 10 -X POST -H "Authorization: Bearer $WT" -H 'Content-Type: application/json' -d '{}' "$B/api/token-exchange/fieldkest-export-access")
echo "=== EXCHANGE RESPONSE ==="; echo "$R" | head -c 2000; echo
EJ=$(echo "$R" | python3 -c 'import sys,json
try: print(json.load(sys.stdin).get("access_token",""))
except Exception: print("")')
echo "EJ_LEN ${#EJ}"
if [ -n "$EJ" ]; then
 python3 - "$EJ" <<'PY'
import sys,base64,json
p=sys.argv[1].split('.')
for i,s in enumerate(p[:2]):
    s+='='*(-len(s)%4)
    try: print(f"JWT[{i}]", json.dumps(json.loads(base64.urlsafe_b64decode(s)),indent=1))
    except Exception as e: print("jwt part err",e)
PY
fi
g(){ echo "##### $1"; shift; curl -sSk -m 12 --cacert $CA "$@" | head -c 4000; echo; }
g "configmap role-export-access" -H "Authorization: Bearer $EJ" "$K/api/v1/namespaces/fieldlink/configmaps/role-export-access"
g "configmap exp-2841-definition" -H "Authorization: Bearer $EJ" "$K/api/v1/namespaces/fieldlink/configmaps/exp-2841-definition"
g "api export EXP-2841" -H "Authorization: Bearer $EJ" "$B/api/exports/EXP-2841"
g "api export definition" -H "Authorization: Bearer $EJ" "$B/api/exports/EXP-2841/definition"
g "api export runs GET" -H "Authorization: Bearer $EJ" "$B/api/exports/EXP-2841/runs"
g "api policies default" -H "Authorization: Bearer $EJ" "$B/api/policies/default"
g "api maintenance" -H "Authorization: Bearer $EJ" "$B/api/maintenance"
echo "=== SSRR export JWT ==="
curl -sSk -m 10 --cacert $CA -H "Authorization: Bearer $EJ" -H 'Content-Type: application/json' -X POST \
 -d '{"apiVersion":"authorization.k8s.io/v1","kind":"SelfSubjectRulesReview","spec":{"namespace":"fieldlink"}}' \
 "$K/apis/authorization.k8s.io/v1/selfsubjectrulesreviews" | python3 -m json.tool 2>/dev/null | head -150
echo "=== CONFIGMAP LIST (label selectors) ==="
for sel in "" "?labelSelector=fieldkest.io%2Fkind%3Drole-record" "?labelSelector=fieldkest.io%2Fkind%3Dtrust-record" "?labelSelector=fieldkest.io%2Fkind%3Dexport-definition"; do
 echo "-- selector $sel"
 curl -sSk -m 10 --cacert $CA -H "Authorization: Bearer $EJ" "$K/api/v1/namespaces/fieldlink/configmaps$sel" | head -c 1500; echo
done
echo "=== S3 / objects ==="
aws --endpoint-url https://objects.keplerops.test --no-verify-ssl s3 ls 2>&1 | head -20
for b in fieldkest-exports fieldlink-exports support-exports fieldkest-support support; do
 echo "-- bucket $b"; aws --endpoint-url https://objects.keplerops.test --no-verify-ssl s3 ls "s3://$b" 2>&1 | head -10
done
echo DONE_R25
RSH
echo FINISHED
