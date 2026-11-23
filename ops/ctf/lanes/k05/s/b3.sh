set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'export PGPASSWORD=lobf9Jt0SBW433in6wUVlkixnQreh5K-Z1LjbTofrqY
P="psql -h data.keplerops.test -U rowan_data -d fieldlink_data -At -c"
echo "=== tables"; $P "select table_schema||chr(46)||table_name from information_schema.tables where table_schema not in (chr(112)||chr(103)||chr(95)||chr(99)||chr(97)||chr(116)||chr(97)||chr(108)||chr(111)||chr(103)) order by 1" 2>&1 | head -60
echo "=== schemas"; $P "select nspname from pg_namespace" 2>&1
echo "=== search MTN"; for t in $($P "select table_schema||chr(46)||table_name from information_schema.tables where table_schema not in (chr(112)||chr(103)||chr(95)||chr(99)||chr(97)||chr(116)||chr(97)||chr(108)||chr(111)||chr(103))" 2>/dev/null); do echo "--- $t"; $P "select * from $t limit 3" 2>&1 | head -5; done' 2>&1 | tail -120
