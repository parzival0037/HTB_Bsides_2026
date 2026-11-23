set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'export PGPASSWORD=lobf9Jt0SBW433in6wUVlkixnQreh5K-Z1LjbTofrqY
P="psql -h data.keplerops.test -U rowan_data -d fieldlink_data -At"
echo "=== tables"; $P -c "select schemaname||chr(46)||tablename||chr(9)||tableowner from pg_tables where schemaname not in ($$pg_catalog$$,$$information_schema$$) order by 1"
echo "=== schemas"; $P -c "select nspname from pg_namespace order by 1"
echo "=== roles"; $P -c "select rolname from pg_roles order by 1" | head -20' 2>&1 | tail -50
