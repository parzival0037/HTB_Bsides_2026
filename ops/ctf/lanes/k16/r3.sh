#!/bin/bash
set +e
ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=10 rowan-dev 'bash -s' <<'RSH'
set +e
CA=$HOME/.local/share/keplerops/ca.crt
JWT=$(kubectl config view --raw -o jsonpath='{.users[0].user.token}')
C=https://cloud-api.keplerops.test
p(){ echo "=== $1"; shift; curl -sS -m 12 --cacert $CA -w '\n[%{http_code}]\n' "$@" | head -c 1500; echo; }
echo "########## BASELINE"
p "GET schedules JWT bearer" -H "Authorization: Bearer $JWT" "$C/api/schedules/SCHED-2841"
p "GET schedules X-Workload-Token JWT" -H "X-Workload-Token: $JWT" "$C/api/schedules/SCHED-2841"
p "GET schedules bare" "$C/api/schedules/SCHED-2841"
echo "########## TOKEN-EXCHANGE ROLES"
for r in export export-runner export-role export_role schedules schedule-runner workload workloads fieldlink-export rowan-workspace workspace; do
  p "POST /api/token-exchange/$r" -X POST -H "Authorization: Bearer $JWT" -H 'Content-Type: application/json' -d '{}' "$C/api/token-exchange/$r"
done
echo "########## WORKSPACE EXCHANGE"
p "GET exchange" -H "Authorization: Bearer $JWT" "$C/api/workspaces/current/token-exchange"
p "POST exchange {}" -X POST -H "Authorization: Bearer $JWT" -H 'Content-Type: application/json' -d '{}' "$C/api/workspaces/current/token-exchange"
p "POST exchange role export" -X POST -H "Authorization: Bearer $JWT" -H 'Content-Type: application/json' -d '{"role":"export"}' "$C/api/workspaces/current/token-exchange"
p "POST exchange X-Workload-Token" -X POST -H "X-Workload-Token: $JWT" -H 'Content-Type: application/json' -d '{}' "$C/api/workspaces/current/token-exchange"
echo "########## DATA WELLKNOWN"
curl -sS -m 10 --cacert $CA "https://data.keplerops.test/.well-known/fieldkest-client" | head -c 2000; echo
echo "########## WORKLOADS WELLKNOWN"
curl -sS -m 10 --cacert $CA "https://workloads.keplerops.test/.well-known/fieldkest-client" | head -c 2000; echo
echo "########## DB"
export PGPASSWORD=lobf9Jt0SBW433in6wUVlkixnQreh5K-Z1LjbTofrqY
P="psql -h data.keplerops.test -U rowan_data -d fieldlink_data -At"
$P -c "select table_schema||'.'||table_name from information_schema.tables where table_schema not in ('pg_catalog','information_schema') order by 1" 2>&1 | head -80
RSH
echo DONE_R3
