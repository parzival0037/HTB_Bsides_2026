set +e
TOK='fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'
G=https://source.keplerops.test
echo "===== GITEA REPOS ====="
curl -sSk -m 10 -H "Authorization: token $TOK" "$G/api/v1/user/repos?limit=100" | python3 -c 'import json,sys
try:
 d=json.load(sys.stdin)
 for r in d: print(r["full_name"], r.get("description"), r.get("updated_at"))
except Exception as e: print("ERR",e)'
echo "===== GITEA SEARCH ====="
curl -sSk -m 10 -H "Authorization: token $TOK" "$G/api/v1/repos/search?q=cloud&limit=50" | python3 -c 'import json,sys
d=json.load(sys.stdin)
for r in d.get("data",[]): print(r["full_name"], r.get("description"))'
echo "===== K8S API RESOURCES ====="
kubectl api-resources 2>&1 | head -40
echo "===== K8S /apis ====="
kubectl get --raw /apis 2>&1 | head -c 1500; echo
echo "===== K8S openapi paths (grep) ====="
kubectl get --raw /openapi/v2 2>/dev/null | head -c 200; echo
echo "===== EXCHANGE PROBES ====="
JWT=$(python3 -c 'import json;print(json.load(open("/home/rowan/.kube/config"))["users"][0]["user"]["token"])')
B=https://cloud-api.keplerops.test
p(){ echo "=== $1"; shift; curl -sSk -m 8 -w '\n[HTTP %{http_code}]\n' "$@" 2>&1 | head -20; }
for r in export exports; do
p "$r POST auth bearer empty" -X POST -H "Authorization: Bearer $JWT" -H 'Content-Type: application/json' -d '{}' "$B/api/token-exchange/$r"
p "$r POST X-Workload-Token" -X POST -H "X-Workload-Token: $JWT" -H 'Content-Type: application/json' -d '{}' "$B/api/token-exchange/$r"
p "$r POST form" -X POST -d "workload_token=$JWT" "$B/api/token-exchange/$r"
p "$r GET query" "$B/api/token-exchange/$r?workload_token=$JWT"
p "$r GET bearer" -H "Authorization: Bearer $JWT" "$B/api/token-exchange/$r"
done
p "workspace exchange bearer JWT body empty" -X POST -H "Authorization: Bearer $JWT" -H 'Content-Type: application/json' -d '{}' "$B/api/workspaces/current/token-exchange"
p "workspace exchange GET bearer JWT" -H "Authorization: Bearer $JWT" "$B/api/workspaces/current/token-exchange"
