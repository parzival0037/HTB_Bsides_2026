set +e
echo "== workspace tables =="
psql service=fieldlink -c '\dt workspace.*' 2>&1
psql service=fieldlink -c '\dv workspace.*' 2>&1
psql service=fieldlink -c '\df workspace.*' 2>&1
echo "== export tables =="
psql service=fieldlink -c '\dt export.*' 2>&1
psql service=fieldlink -c '\d export.partition_bindings' 2>&1
psql service=fieldlink -c 'select * from export.partition_bindings' 2>&1
echo "== support tables =="
psql service=fieldlink -c '\dt support.*' 2>&1
echo "== all non-pg tables =="
psql service=fieldlink -Atc "select table_schema||'.'||table_name from information_schema.tables where table_schema not in ('pg_catalog','information_schema')" 2>&1
