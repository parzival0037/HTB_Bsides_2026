set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'RSH'
set +e
export PGPASSWORD=lobf9Jt0SBW433in6wUVlkixnQreh5K-Z1LjbTofrqY
P="psql -h data.keplerops.test -U rowan_data -d fieldlink_data -At"
echo "=== schemas"; $P -c "select nspname from pg_namespace order by 1"
echo "=== all tables"; $P -c "select schemaname||chr(46)||tablename from pg_tables where schemaname not in ('"'"'pg_catalog'"'"','"'"'information_schema'"'"') order by 1"
echo "=== export tables cols"
for t in $($P -c "select tablename from pg_tables where schemaname='"'"'export'"'"' order by 1"); do
  echo "--- export.$t"; $P -c "select string_agg(column_name||'"'"':'"'"'||data_type, '"'"', '"'"') from information_schema.columns where table_schema='"'"'export'"'"' and table_name='"'"'$t'"'"'"
done
echo "=== support tables cols"
for t in $($P -c "select tablename from pg_tables where schemaname='"'"'support'"'"' order by 1"); do
  echo "--- support.$t"; $P -c "select string_agg(column_name||'"'"':'"'"'||data_type, '"'"', '"'"') from information_schema.columns where table_schema='"'"'support'"'"' and table_name='"'"'$t'"'"'"
done
echo "=== S3"
export AWS_CA_BUNDLE=$HOME/.local/share/keplerops/ca.crt
aws --endpoint-url https://objects.keplerops.test s3 ls 2>&1 | head
echo "-- fieldlink-exports"
aws --endpoint-url https://objects.keplerops.test s3 ls s3://fieldlink-exports 2>&1 | head -40
echo "=== K8S"
kubectl -n fieldlink get jobs,pods,secrets,configmaps 2>&1 | head -60
RSH
