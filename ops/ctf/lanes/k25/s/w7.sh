S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'RSH'
set +e
Q(){ psql service=fieldlink -At -F'|' -c "$1" 2>&1; }
echo "=== tables (all)"
Q "select n.nspname||'.'||c.relname||' kind='||c.relkind||' sel='||has_table_privilege(current_user,c.oid,'SELECT') from pg_class c join pg_namespace n on n.oid=c.relnamespace where c.relkind in ('r','v','m','p') and n.nspname not in ('pg_catalog','information_schema') order by 1;"
echo "=== workspace tables via pg_class"
Q "select n.nspname||'.'||c.relname from pg_class c join pg_namespace n on n.oid=c.relnamespace where n.nspname='workspace';"
echo "=== schema privileges"
Q "select nspname, has_schema_privilege(current_user,oid,'USAGE') from pg_namespace where nspname not like 'pg_%' and nspname<>'information_schema';"
echo "=== platform-access.md"
cat /home/rowan/work/platform-access.md
echo "=== identity-access.md"
cat /home/rowan/work/identity-access.md
echo "=== core file"
ls -la /home/rowan/core /home/rowan/sj.txt 2>&1; file /home/rowan/core 2>&1 | head -2
echo "=== bash history tail"
tail -60 /home/rowan/.bash_history 2>&1
RSH
