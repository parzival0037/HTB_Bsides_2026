set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'RSH'
set +e
export PGPASSWORD=lobf9Jt0SBW433in6wUVlkixnQreh5K-Z1LjbTofrqY
P="psql -h data.keplerops.test -U rowan_data -d fieldlink_data -At"
echo "###### schemas"
$P -c "select nspname from pg_namespace order by 1"
echo "###### all tables"
$P -c "select schemaname||chr(46)||tablename from pg_tables where schemaname not in ('pg_catalog','information_schema') order by 1"
echo "###### export.* columns"
for t in $($P -c "select tablename from pg_tables where schemaname='export' order by 1"); do
  echo "--- export.$t"
  $P -c "select string_agg(column_name||':'||data_type, ', ') from information_schema.columns where table_schema='export' and table_name='$t'"
  echo "    rows: $($P -c "select count(*) from export.$t" 2>&1)"
done
echo "###### support.* columns"
for t in $($P -c "select tablename from pg_tables where schemaname='support' order by 1"); do
  echo "--- support.$t"
  $P -c "select string_agg(column_name||':'||data_type, ', ') from information_schema.columns where table_schema='support' and table_name='$t'"
  echo "    rows: $($P -c "select count(*) from support.$t" 2>&1)"
done
echo "###### workspace.* columns"
for t in $($P -c "select tablename from pg_tables where schemaname='workspace' order by 1"); do
  echo "--- workspace.$t"
  $P -c "select string_agg(column_name||':'||data_type, ', ') from information_schema.columns where table_schema='workspace' and table_name='$t'"
  echo "    rows: $($P -c "select count(*) from workspace.$t" 2>&1)"
done
echo "###### workspace files"
find ~/work -maxdepth 3 -type f 2>/dev/null | head -80
echo "###### grep export in work"
grep -rniE "export|handover|EXP-2841|hook|endpoint|destination" ~/work ~/README* ~/.config 2>/dev/null | head -60
RSH
echo DONE_S2
