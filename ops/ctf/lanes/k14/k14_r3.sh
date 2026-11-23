set +e
ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=8 rowan-dev 'bash -s' <<'RSH'
set +e
export AWS_CA_BUNDLE=/home/rowan/.local/share/keplerops/ca.crt
JWT=$(kubectl config view --raw -o jsonpath='{.users[0].user.token}')
E=https://objects.keplerops.test
echo "=== IAM ==="
aws --endpoint-url $E iam list-roles 2>&1 | head -30
for r in rowan.ito rowan-workspace support-export support-export-reader fieldlink-support-export export-reader fieldlink-export-reader workload fieldlink-workload support; do
  echo "-- get-role $r"; aws --endpoint-url $E iam get-role --role-name "$r" 2>&1 | head -20
done
echo "=== S3 list-buckets ==="
aws --endpoint-url $E s3api list-buckets 2>&1 | head -30
aws --endpoint-url $E s3 ls 2>&1 | head -20
echo "=== STS web identity ==="
for r in rowan-workspace fieldlink-workload workload support-export support-export-reader fieldlink-support-export export-reader; do
  echo "-- $r"
  aws --endpoint-url $E sts assume-role-with-web-identity --role-arn "arn:aws:iam::000000000000:role/$r" --role-session-name probe --web-identity-token "$JWT" 2>&1 | head -8
done
echo "=== CLOUD-API MISC ==="
C=https://cloud-api.keplerops.test
for p in openapi.json api/openapi.json docs api docs/openapi.json api; do
  code=$(curl -sSk -m 6 -o /tmp/c -w '%{http_code}' -H "Authorization: Bearer $JWT" "$C/$p")
  echo "-- $p -> $code :: $(head -c 400 /tmp/c | tr '\n' ' ')"
done
echo "=== AUTH HEADER VARIANTS trust TR-1 ==="
for h in "X-Workload-Token: $JWT" "X-Workload-Identity: $JWT" "X-Identity-Token: $JWT" "Workload-Token: $JWT" "X-Workload: $JWT" "Authorization: Workload $JWT" "Authorization: Bearer workload:$JWT"; do
  code=$(curl -sSk -m 6 -o /tmp/c -w '%{http_code}' -H "$h" "$C/api/trust-records/TR-1")
  echo "-- [$h] -> $code :: $(head -c 200 /tmp/c | tr '\n' ' ')"
done
for q in "workload_token=$JWT" "token=$JWT" "workload=$JWT"; do
  code=$(curl -sSk -m 6 -o /tmp/c -w '%{http_code}' "$C/api/trust-records/TR-1?$q")
  echo "-- query $q -> $code :: $(head -c 200 /tmp/c | tr '\n' ' ')"
done
echo "=== WORKLOADS PROBES (Bearer JWT) ==="
for h in workloads workload id identity; do
 for p in api api/workloads api/workloads/current api/workloads/current/token api/workspaces api/workspaces/current api/workspaces/current/token api/token api/identity api/trust-records/TR-1 api/token-exchange/rowan-workspace; do
  code=$(curl -sSk -m 6 -o /tmp/c -w '%{http_code}' -H "Authorization: Bearer $JWT" "https://$h.keplerops.test/$p")
  echo "-- $h/$p -> $code :: $(head -c 160 /tmp/c | tr '\n' ' ')"
 done
done
echo "=== ID ROOT/WELLKNOWN ==="
for u in https://id.keplerops.test/ https://id.keplerops.test/.well-known/fieldkest-client https://id.keplerops.test/.well-known/openid-configuration; do
 echo "-- $u"; curl -sSk -m 6 -i "$u" | head -c 700; echo
done
RSH
echo DONE_K14_R3
