set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'RSH'
set +e
C=https://cloud-api.keplerops.test
BASIC=$(printf 'rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo' | base64 -w0)
W=$(curl -sS -m 15 -k -X POST -H "Authorization: Basic $BASIC" -H "Content-Type: application/json" -d '{}' "$C/api/workspaces/current/token-exchange" | python3 -c 'import json,sys;print(json.load(sys.stdin)["access_token"])')
echo "W=${W:0:30}..."
for role in export export-reader export-writer exports export-operator data-export fieldlink-export workload runner report; do
  echo "-- role $role (basic)"; curl -sS -m 12 -k -X POST -H "Authorization: Basic $BASIC" -H "Content-Type: application/json" -d '{}' -w " [%{http_code}]" "$C/api/token-exchange/$role" | head -c 400; echo
done
echo "=== GET role-exchange"
for role in export; do curl -sS -m 12 -k -H "Authorization: Basic $BASIC" -w " [%{http_code}]" "$C/api/token-exchange/$role" | head -c 300; echo; done
echo "=== role-exchange with workload token"
for role in export export-reader; do echo "-- $role"; curl -sS -m 12 -k -X POST -H "Authorization: Bearer $W" -H "Content-Type: application/json" -d '{}' -w " [%{http_code}]" "$C/api/token-exchange/$role" | head -c 500; echo; done
RSH
