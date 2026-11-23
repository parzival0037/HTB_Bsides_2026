set +e
ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=8 rowan-dev 'bash -s' <<'RSH'
set +e
CA=$HOME/.local/share/keplerops/ca.crt
B=https://cloud-api.keplerops.test
U="rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
WT=$(curl -sSk -m 10 -u "$U" -X POST -H 'Content-Type: application/json' -d '{}' "$B/api/workspaces/current/token-exchange" | python3 -c 'import sys,json;print(json.load(sys.stdin).get("access_token",""))')
EJ=$(curl -sSk -m 10 -X POST -H "Authorization: Bearer $WT" -H 'Content-Type: application/json' -d '{}' "$B/api/token-exchange/fieldkest-export-access" | python3 -c 'import sys,json;print(json.load(sys.stdin).get("access_token",""))')
echo "########## SCHEDULE RECORD"
curl -sSk -m 10 -H "Authorization: Bearer $EJ" "$B/api/schedules/SCHED-2841" | head -c 3000; echo
echo "########## CRONJOB full data tail"
curl -sSk -m 10 -H "Authorization: Bearer $EJ" "$B/api/policies/sched-2841" | head -c 1000; echo
echo "########## DB service config"
cat ~/.pg_service.conf 2>/dev/null; echo
echo "########## partition_bindings"
psql service=fieldlink -c '\d export.partition_bindings' 2>&1 | head -30
psql service=fieldlink -c 'select * from export.partition_bindings' 2>&1 | head -40
echo "########## information_schema visible tables"
psql service=fieldlink -Atc "select table_schema||'.'||table_name from information_schema.tables where table_schema not in ('pg_catalog','information_schema') order by 1" 2>&1 | head -60
psql service=fieldlink -Atc "select table_schema||'.'||table_name||'.'||column_name from information_schema.columns where table_schema not in ('pg_catalog','information_schema') order by 1" 2>&1 | head -80
echo "########## STS with EJ + role candidates"
export AWS_CA_BUNDLE=$CA
for r in support-export-editor svc-fieldlink-export fieldkest-export-access export-access fieldkest-exports support-export; do
 echo "-- role $r"
 aws --endpoint-url https://objects.keplerops.test sts assume-role-with-web-identity --role-session-name k14 --role-arn "arn:aws:iam::000000000000:role/$r" --web-identity-token "$EJ" 2>&1 | head -c 400; echo
done
echo "########## ANON bucket listing/keys"
curl -sSk -m 10 "https://objects.keplerops.test/" | head -c 1500; echo
for b in fieldkest-exports fieldkest-workspaces fieldlink-exports; do
 echo "-- anon list $b"; curl -sSk -m 10 "https://objects.keplerops.test/$b?list-type=2" | head -c 1200; echo
done
echo DONE_R33
RSH
echo FINISHED
