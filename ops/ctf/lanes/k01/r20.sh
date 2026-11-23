set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'RSH'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
echo "===PG TABLES==="
PGPASSFILE=/home/rowan/.pgpass psql "service=fieldlink" -c "select table_schema,table_name from information_schema.tables where table_schema in ('export','public','support') order by 1,2;" 2>&1 | head -60
echo "===PG whoami/version==="
PGPASSFILE=/home/rowan/.pgpass psql "service=fieldlink" -c 'select current_user,version();' 2>&1 | head -8
echo "===JENKINS AUTH==="
curl -sS -m 10 --cacert $CA -u 'rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo' 'https://ci.keplerops.test/api/json?tree=jobs[name]' | head -c 800; echo
echo "===MATERIAL SIZES==="
ls -la ~/.local/share/keplerops/
echo "===NPM 7.4.2==="
cd /tmp && npm view @keplerops/fieldlink-connector@7.4.2 2>&1 | head -25
RSH
