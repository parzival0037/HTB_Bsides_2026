set +e
ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=8 rowan-dev 'bash -s' <<'RSH'
set +e
export AWS_CA_BUNDLE=/home/rowan/.local/share/keplerops/ca.crt
echo "=== SCHEMAS/TABLES ==="
psql service=fieldlink -Atc "select table_schema||'.'||table_name from information_schema.tables where table_schema not in ('pg_catalog','information_schema') order by 1" 2>&1 | head -100
echo "=== COLUMNS mentioning trust/workload/role/identity ==="
psql service=fieldlink -Atc "select table_schema||'.'||table_name||'.'||column_name from information_schema.columns where table_schema not in ('pg_catalog','information_schema') and (column_name ilike '%trust%' or column_name ilike '%token%' or column_name ilike '%role%' or column_name ilike '%audience%' or column_name ilike '%subject%') order by 1" 2>&1 | head -100
echo "=== DB ROLES ==="
psql service=fieldlink -c '\du' 2>&1 | head -20
echo "=== DUMP ==="
aws --endpoint-url https://objects.keplerops.test s3 cp s3://fieldlink-exports/backups/company-history.dump /tmp/ch.dump 2>&1 | tail -2
ls -la /tmp/ch.dump; file /tmp/ch.dump
echo "--- strings"; strings /tmp/ch.dump | head -120
echo "=== custom schema search ==="
psql service=fieldlink -Atc "select nspname from pg_namespace where nspname not like 'pg_%' and nspname<>'information_schema'" 2>&1
RSH
echo DONE_K14_R14
