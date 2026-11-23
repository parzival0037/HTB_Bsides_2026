set +e
ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=8 rowan-dev 'bash -s' <<'RSH'
set +e
JWT=$(kubectl config view --raw -o jsonpath='{.users[0].user.token}')
C=https://cloud-api.keplerops.test
p(){ echo "--- $1"; shift; curl -sSk -m 8 -w '\n[HTTP %{http_code}]\n' "$@" | head -c 800; echo; }
echo "=== ROLE EXCHANGE JWT BEARER ==="
for r in rowan-workspace workspace workloads workload workoad fieldlink fieldlink-workspace fieldlink-workload fieldkest-workspace support support-export support-export-reader export-reader trust trust-reader trust-record trust-records TR-1 admin reader viewer default objects object-storage data export exports record-reader support-reader; do
 p "role=$r" -X POST -H "Authorization: Bearer $JWT" -H 'Content-Type: application/json' -d '{}' "$C/api/token-exchange/$r"
done
echo "=== ROLE EXCHANGE POST BODY TOKENS ==="
for f in token workload_token jwt service_account_token; do
 p "body $f" -X POST -H 'Content-Type: application/json' -d "{\"$f\":\"$JWT\"}" "$C/api/token-exchange/rowan-workspace"
done
echo "=== TRUST RECORD with JWT in other headers ==="
for h in "Authorization: JWT $JWT" "Authorization: Bearer $JWT" "X-Workload-Token: Bearer $JWT" "X-Workspace-Token: Bearer $JWT"; do
 p "TR-1 [$h]" -H "$h" "$C/api/trust-records/TR-1"
done
echo "=== TRUST IDS ==="
for t in TR-1 TR-2 TR-3 TR-4 TR-5 TR-01 TR-001 TR-WORKLOAD TR-ROWAN TR-EXP-2841; do
 code=$(curl -sSk -m 6 -o /tmp/t -w '%{http_code}' -H "Authorization: Bearer $JWT" "$C/api/trust-records/$t")
 echo "-- $t -> $code :: $(head -c 160 /tmp/t | tr '\n' ' ')"
done
RSH
echo DONE_K14_R13
