#!/bin/bash
H='ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ConnectTimeout=8 -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180'
$H 'cat > /tmp/q.sql' <<'SQL'
select n.nspname, c.relname, c.relkind from pg_class c join pg_namespace n on n.oid=c.relnamespace
where c.relkind in ('r','v','m','p') and n.nspname not like 'pg_%' and n.nspname<>'information_schema'
order by 1,2;
SQL
$H 'psql service=fieldlink -f /tmp/q.sql' 2>&1 | head -80
