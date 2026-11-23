set +e
U="rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
B=https://cloud-api.keplerops.test
K=https://cloud-api.keplerops.test:6443
CA=/home/rowan/.local/share/keplerops/ca.crt
WT=$(curl -sSk -m 10 -u "$U" -X POST -H 'Content-Type: application/json' -d '{}' "$B/api/workspaces/current/token-exchange" | python3 -c 'import sys,json;print(json.load(sys.stdin)["access_token"])')
echo "WT len ${#WT}"
echo "===== SSRR ====="
curl -sSk -m 10 --cacert $CA -H "Authorization: Bearer $WT" -H 'Content-Type: application/json' -X POST \
 -d '{"apiVersion":"authorization.k8s.io/v1","kind":"SelfSubjectRulesReview","spec":{"namespace":"fieldlink"}}' \
 "$K/apis/authorization.k8s.io/v1/selfsubjectrulesreviews" | python3 -m json.tool 2>/dev/null | head -120
echo "===== SSAR matrix ====="
for r in "get|configmaps|" "list|configmaps|" "get|secrets|" "list|secrets|" "get|serviceaccounts|" "list|serviceaccounts|" "get|leases|coordination.k8s.io" "list|leases|coordination.k8s.io" "get|rolebindings|rbac.authorization.k8s.io" "list|rolebindings|rbac.authorization.k8s.io" "list|pods|" "get|pods|" "list|deployments|apps" "list|statefulsets|apps" "get|namespaces|" "list|endpoints|" "get|services|" "list|jobs|batch" "list|cronjobs|batch"; do
 IFS='|' read -r V R G <<EOF
$r
EOF
 if [ -z "$G" ]; then GA='"group":""'; else GA="\"group\":\"$G\""; fi
 RES=$(curl -sSk -m 8 --cacert $CA -H "Authorization: Bearer $WT" -H 'Content-Type: application/json' -X POST \
  -d "{\"apiVersion\":\"authorization.k8s.io/v1\",\"kind\":\"SelfSubjectAccessReview\",\"spec\":{\"resourceAttributes\":{\"namespace\":\"fieldlink\",\"verb\":\"$V\",\"resource\":\"$R\",$GA}}}" \
  "$K/apis/authorization.k8s.io/v1/selfsubjectaccessreviews" | python3 -c 'import sys,json
try: print(json.load(sys.stdin)["status"].get("allowed"))
except Exception as e: print("ERR")')
 echo "$V $R ($G) -> $RES"
done
echo "===== DIRECT GETS (allow/deny) ====="
g(){ echo "--- $1"; curl -sSk -m 10 --cacert $CA -H "Authorization: Bearer $WT" -w '\n[HTTP %{http_code}]\n' "$K$1" | head -c 1200; echo; }
g "/api/v1/namespaces/fieldlink/configmaps"
g "/api/v1/namespaces/fieldlink/secrets"
g "/api/v1/namespaces/fieldlink/serviceaccounts"
g "/apis/coordination.k8s.io/v1/namespaces/fieldlink/leases"
g "/apis/rbac.authorization.k8s.io/v1/namespaces/fieldlink/rolebindings"
g "/apis/rbac.authorization.k8s.io/v1/namespaces/fieldlink/roles"
echo "===== ROLE/RB NAMES visible via cloud-api? ====="
