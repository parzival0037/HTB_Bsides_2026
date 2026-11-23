set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'RSH'
set +e
C=https://cloud-api.keplerops.test
BASIC=$(printf 'rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo' | base64 -w0)
FT=fk_workload_fixture_7nNUHpIQRCb5s2SLo7lb0sJH9LXByeMK
t(){ echo "--- $1"; shift; curl -sS -m 15 -k "$@" -w " [%{http_code}]" "${URL:-$C/api/exports/EXP-2841}" | head -c 1200; echo; }
t fixture -H "Authorization: Bearer $FT"
t xtok -H "X-Export-Token: $FT"
t export-hdr -H "Authorization: Bearer export:$FT"
echo "=== POST token exchange with basic"
curl -sS -m 15 -k -X POST -H "Authorization: Basic $BASIC" -H "Content-Type: application/json" -d '{}' -w " [%{http_code}]" "$C/api/workspaces/current/token-exchange"; echo
curl -sS -m 15 -k -X POST -H "Authorization: Basic $BASIC" -H "Content-Type: application/json" -d '{"role":"export"}' -w " [%{http_code}]" "$C/api/workspaces/current/token-exchange"; echo
curl -sS -m 15 -k -X POST -H "Authorization: Basic $BASIC" -H "Content-Type: application/json" -d '{"scope":"exports"}' -w " [%{http_code}]" "$C/api/workspaces/current/token-exchange"; echo
echo "=== export with fixture after exchange"
curl -sS -m 15 -k -H "Authorization: Bearer $FT" -w " [%{http_code}]" "$C/api/exports/EXP-2841"; echo
echo "=== schedules"
curl -sS -m 15 -k -H "Authorization: Bearer $FT" -w " [%{http_code}]" "$C/api/schedules/SCHED-2841"; echo
echo "=== trust record"
curl -sS -m 15 -k -H "Authorization: Basic $BASIC" -w " [%{http_code}]" "$C/api/trust-records/TRUST-FLX-04"; echo
RSH
