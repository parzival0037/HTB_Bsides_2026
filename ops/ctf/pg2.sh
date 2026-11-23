set +e
ssh -o BatchMode=yes rowan-dev "psql service=fieldlink -c '\dn' -c 'select current_user, current_schema()' 2>&1 | head -20"
echo "=== accessible tables ==="
ssh -o BatchMode=yes rowan-dev "psql service=fieldlink -c \"select table_schema||'.'||table_name from information_schema.tables where table_schema not in ('pg_catalog','information_schema') order by 1 limit 40\" 2>&1 | head -40"
