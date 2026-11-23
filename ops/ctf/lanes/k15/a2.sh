set +e
ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev 'bash -s' <<'RSH'
set +e
CA=$HOME/.local/share/keplerops/ca.crt
echo "###### psql service config"
cat ~/.pg_service.conf 2>/dev/null
echo "###### tables"
psql service=fieldlink -Atc "select table_schema||'.'||table_name from information_schema.tables where table_schema not in ('pg_catalog','information_schema') order by 1" 2>&1 | head -80
echo "###### gitea repos"
A="Authorization: Basic $(printf "rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo" | base64 -w0)"
curl -sS -m 15 --cacert $CA -H "$A" "https://source.keplerops.test/api/v1/repos/search?limit=50" | python3 -c "import json,sys;d=json.load(sys.stdin);[print(r['full_name'],r.get('default_branch')) for r in d.get('data',[])]" 2>&1 | head -40
echo "###### cloud-api OPTIONS"
C=https://cloud-api.keplerops.test
curl -sS -m 10 --cacert $CA -X OPTIONS -i "$C/api/exports/EXP-2841" | head -20
RSH
echo DONE_A2
