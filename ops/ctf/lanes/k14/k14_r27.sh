set +e
ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=8 rowan-dev 'bash -s' <<'RSH'
set +e
CA=$HOME/.local/share/keplerops/ca.crt
B=https://cloud-api.keplerops.test
K=https://cloud-api.keplerops.test:6443
U="rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
WT=$(curl -sSk -m 10 -u "$U" -X POST -H 'Content-Type: application/json' -d '{}' "$B/api/workspaces/current/token-exchange" | python3 -c 'import sys,json;print(json.load(sys.stdin).get("access_token",""))')
EJ=$(curl -sSk -m 10 -X POST -H "Authorization: Bearer $WT" -H 'Content-Type: application/json' -d '{}' "$B/api/token-exchange/fieldkest-export-access" | python3 -c 'import sys,json;print(json.load(sys.stdin).get("access_token",""))')
g(){ n="$1"; shift; echo "##### $n"; curl -sSk -m 10 --cacert $CA -w '\n[%{http_code}]\n' "$@" | head -c 6000; echo; }
echo "########## K8S JOB / CRONJOB"
g "job exp-2841" -H "Authorization: Bearer $EJ" "$K/apis/batch/v1/namespaces/fieldlink/jobs/exp-2841"
g "cronjob sched-2841" -H "Authorization: Bearer $EJ" "$K/apis/batch/v1/namespaces/fieldlink/cronjobs/sched-2841"
g "pods get exp-2841" -H "Authorization: Bearer $EJ" "$K/api/v1/namespaces/fieldlink/pods/exp-2841"
g "pods list" -H "Authorization: Bearer $EJ" "$K/api/v1/namespaces/fieldlink/pods"
echo "########## POLICY ID CANDIDATES"
for p in exp-2841-definition exp-2841 sched-2841 support-case-history EXP-2841 export-2841 support-export EXP-2841-rowan EXP-2841-maya; do
 g "EJ /api/policies/$p" -H "Authorization: Bearer $EJ" "$B/api/policies/$p"
done
echo "########## EXPORT RUNS VARIANTS"
for u in "api/exports/EXP-2841/runs" "api/exports/EXP-2841/runs?limit=10" "api/exports/EXP-2841/run" "api/exports/EXP-2841/records"; do
 g "EJ $u" -H "Authorization: Bearer $EJ" "$B/$u"
done
echo "########## DATASET RECORD CANDIDATES (support-case-history)"
for u in "api/datasets/support-case-history" "api/exports/EXP-2841/dataset" "api/exports/EXP-2841/data" "api/support/exports/EXP-2841" "api/support/data/EXP-2841"; do
 g "EJ $u" -H "Authorization: Bearer $EJ" "$B/$u"
done
echo DONE_R27
RSH
echo FINISHED
