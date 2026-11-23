set +e
B=https://cloud-api.keplerops.test
JWT=$(kubectl config view --raw -o jsonpath='{.users[0].user.token}')
echo "JWT len ${#JWT}  head ${JWT:0:30}"
probe(){ label="$1"; shift; echo "=== $label"; curl -sSk -m 8 -w '\n[HTTP %{http_code}]\n' "$@" | head -40; }
probe "JWT bearer /token-exchange/rowan-workspace" -X POST -H "Authorization: Bearer $JWT" -H 'Content-Type: application/json' -d '{}' "$B/api/token-exchange/rowan-workspace"
probe "JWT json workload_token" -X POST -H 'Content-Type: application/json' -d "{\"workload_token\":\"$JWT\"}" "$B/api/token-exchange/rowan-workspace"
probe "JWT GET bearer exchange" -H "Authorization: Bearer $JWT" "$B/api/token-exchange/rowan-workspace"
probe "JWT bearer /api/workspaces/current/token-exchange" -X POST -H "Authorization: Bearer $JWT" -H 'Content-Type: application/json' -d '{}' "$B/api/workspaces/current/token-exchange"
probe "JWT GET /api/maintenance" -H "Authorization: Bearer $JWT" "$B/api/maintenance"
probe "JWT GET /api/exports/EXP-2841" -H "Authorization: Bearer $JWT" "$B/api/exports/EXP-2841"
echo "== other host roots =="
for h in workloads workload cloud-api data; do echo "--- $h"; curl -sSk -m 6 -i "https://$h.keplerops.test/" | head -12; done
