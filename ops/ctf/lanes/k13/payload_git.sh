set +e
TOK='fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'
G=https://source.keplerops.test
echo "===== USER ====="
curl -sSk -m 10 -H "Authorization: token $TOK" "$G/api/v1/user" | head -c 800; echo
echo "===== USER REPOS ====="
curl -sSk -m 10 -H "Authorization: token $TOK" "$G/api/v1/user/repos?limit=100" | head -c 3000; echo
echo "===== SEARCH ====="
curl -sSk -m 10 -H "Authorization: token $TOK" "$G/api/v1/repos/search?limit=50&q=" | head -c 4000; echo
echo "===== ORGS ====="
curl -sSk -m 10 -H "Authorization: token $TOK" "$G/api/v1/orgs" | head -c 1000; echo
echo "===== APIS GROUPS (nonstandard) ====="
kubectl get --raw /apis 2>/dev/null | python3 -c 'import json,sys
d=json.load(sys.stdin)
for g in d.get("groups",[]): print(g["name"], [v["groupVersion"] for v in g["versions"]])'
echo "===== CRDS ====="
kubectl get crd 2>&1 | head -20
echo "===== /apis/cloud-api ====="
kubectl get --raw /apis/cloud.keplerops.test 2>&1 | head -c 500; echo
