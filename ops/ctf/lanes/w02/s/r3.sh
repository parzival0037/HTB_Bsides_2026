SSH="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -i $HOME/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$SSH 'bash -s' <<'REMOTE'
echo "### tables"
psql service=fieldlink -Atc "select table_schema||'.'||table_name from information_schema.tables where table_schema not in ('pg_catalog','information_schema') order by 1"
echo "### schemas"
psql service=fieldlink -Atc "select schema_name from information_schema.schemata"
REMOTE
