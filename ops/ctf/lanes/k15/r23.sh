set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'RSH'
set +e
CA=$HOME/.local/share/keplerops/ca.crt
C=https://cloud-api.keplerops.test
JWT=$(kubectl config view --raw -o jsonpath='{.users[0].user.token}')
BASIC=$(printf 'rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo' | base64 -w0)
SUP="fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b"
try(){ local label="$1"; shift; echo "--- $label"; curl -sS -m 15 -k "$@" -w " [%{http_code}]" "$C/api/exports/EXP-2841" | head -c 800; echo; }
try noauth
try kube -H "Authorization: Bearer $JWT"
try basic -H "Authorization: Basic $BASIC"
try support -H "Authorization: Bearer $SUP"
echo "=== token-exchange GET"
for h in "" "Authorization: Bearer $JWT" "Authorization: Basic $BASIC"; do
 echo "-- hdr=[$h]"; curl -sS -m 15 -k ${h:+-H "$h"} -w " [%{http_code}]" "$C/api/workspaces/current/token-exchange" | head -c 600; echo
done
echo "=== token-exchange POST"
curl -sS -m 15 -k -X POST -H "Authorization: Bearer $JWT" -H "Content-Type: application/json" -d '{}' -w " [%{http_code}]" "$C/api/workspaces/current/token-exchange" | head -c 800; echo
RSH
