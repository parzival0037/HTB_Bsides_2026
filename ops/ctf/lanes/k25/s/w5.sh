S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'RSH'
set +e
P="psql service=fieldlink"
echo "=== whoami"; $P -At -c "select current_user,current_database();"
echo "=== schemas"; $P -At -c "select schema_name from information_schema.schemata order by 1;"
echo "=== roles"; $P -At -c "select rolname from pg_roles order by 1;"
echo "=== partition_bindings desc"; $P -c "\d export.partition_bindings"
echo "=== partition_bindings rows"; $P -x -c "select * from export.partition_bindings order by 1,2;"
echo "=== grants"; $P -At -F'|' -c "select table_schema,table_name,privilege_type,grantee from information_schema.role_table_grants where grantee in ('rowan_data','PUBLIC') order by 1,2;"
echo "=== pg service files"; ls -la ~/.pg_service.conf ~/.pgpass 2>&1; cat ~/.pg_service.conf 2>&1; echo; cat ~/.pgpass 2>&1
echo "=== find dumps/backups"; ls -la ~/w09 2>/dev/null; find / -name '*.dump' -o -name '*.sql' 2>/dev/null | grep -v proc | head -20
RSH
