set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'export PGPASSWORD=lobf9Jt0SBW433in6wUVlkixnQreh5K-Z1LjbTofrqY
P="psql -h data.keplerops.test -U rowan_data -d fieldlink_data -At"
for sch in public support export workspace; do
echo "===== schema $sch"
$P -c "select tablename||chr(9)||tableowner from pg_tables where schemaname = '\''$sch'\'' order by 1"
for t in $($P -c "select tablename from pg_tables where schemaname = '\''$sch'\'' order by 1"); do
  echo "--- $sch.$t columns:"; $P -c "select string_agg(column_name||'\'':'\''||data_type, '\'', '\'') from information_schema.columns where table_schema='\''$sch'\'' and table_name='\''$t'\''"
done
done' 2>&1 | tail -80
