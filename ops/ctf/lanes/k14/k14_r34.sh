set +e
ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=8 rowan-dev 'bash -s' <<'RSH'
set +e
CA=$HOME/.local/share/keplerops/ca.crt
B=https://cloud-api.keplerops.test
K=https://cloud-api.keplerops.test:6443
U="rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
WT=$(curl -sSk -m 10 -u "$U" -X POST -H 'Content-Type: application/json' -d '{}' "$B/api/workspaces/current/token-exchange" | python3 -c 'import sys,json;print(json.load(sys.stdin).get("access_token",""))')
EJ=$(curl -sSk -m 10 -X POST -H "Authorization: Bearer $WT" -H 'Content-Type: application/json' -d '{}' "$B/api/token-exchange/fieldkest-export-access" | python3 -c 'import sys,json;print(json.load(sys.stdin).get("access_token",""))')
g(){ n="$1"; shift; echo "##### $n"; curl -sSk -m 20 --cacert $CA -w '\n[%{http_code}]\n' "$@" | head -c 3000; echo; }
echo "########## SCHEDULE ROUTES"
g "GET runs" -H "Authorization: Bearer $EJ" "$B/api/schedules/SCHED-2841/runs"
g "GET attestation" -H "Authorization: Bearer $EJ" "$B/api/schedules/SCHED-2841/attestation"
g "GET startup" -H "Authorization: Bearer $EJ" "$B/api/schedules/SCHED-2841/startup"
g "GET hook" -H "Authorization: Bearer $EJ" "$B/api/schedules/SCHED-2841/hook"
g "POST runs {}" -X POST -H "Authorization: Bearer $EJ" -H 'Content-Type: application/json' -d '{}' "$B/api/schedules/SCHED-2841/runs"
echo "########## PATCH schedule startup_hook (dry attempts with GET only first)"
g "PATCH startup_hook" -X PATCH -H "Authorization: Bearer $EJ" -H 'Content-Type: application/json' -d '{"startup_hook":{"argv":["fk-support-export","--export","EXP-2841"]}}' "$B/api/schedules/SCHED-2841"
g "GET schedule after" -H "Authorization: Bearer $EJ" "$B/api/schedules/SCHED-2841"
echo "########## POST runs with startup args"
for body in '{"startup_config":"EXP-2841"}' '{"startup_hook":{"argv":["fk-support-export","--export","EXP-2841"]}}' '{"marker":"cinder","startup_config":"EXP-2841"}'; do
 g "POST runs $body" -X POST -H "Authorization: Bearer $EJ" -H 'Content-Type: application/json' -d "$body" "$B/api/schedules/SCHED-2841/runs"
done
echo "########## SCHEDULER HOSTS"
for h in scheduler fieldkest-scheduler workloads.scheduler scheduler.keplerops.test; do
 echo "-- $h"; getent hosts "$h" 2>/dev/null; getent hosts "$h.keplerops.test" 2>/dev/null
done
for h in scheduler.keplerops.test fieldkest-scheduler.keplerops.test scheduler; do
 g "wellknown $h" "https://$h.keplerops.test/.well-known/fieldkest-client"
done
echo "########## JWKS / SA tokens in cluster (export cannot create token) - list SAs via API?"
g "SA list" -H "Authorization: Bearer $EJ" "$K/api/v1/namespaces/fieldlink/serviceaccounts"
g "CM maint names" -H "Authorization: Bearer $EJ" "$K/api/v1/namespaces/fieldlink/configmaps/maintenance-flk-01"
g "CM policy-fieldlink-maintenance" -H "Authorization: Bearer $EJ" "$K/api/v1/namespaces/fieldlink/configmaps/policy-fieldlink-maintenance"
g "CM maint-flk-01" -H "Authorization: Bearer $EJ" "$K/api/v1/namespaces/fieldlink/configmaps/maint-flk-01"
g "CM workload-maint" -H "Authorization: Bearer $EJ" "$K/api/v1/namespaces/fieldlink/configmaps/workload-maint-flk-01"
echo DONE_R34
RSH
echo FINISHED
