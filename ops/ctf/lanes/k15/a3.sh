set +e
ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev 'bash -s' <<'RSH'
set +e
echo "###### schemas"
psql service=fieldlink -Atc "select nspname from pg_namespace where nspname not like 'pg_%' and nspname<>'information_schema'" 2>&1
echo "###### partition_bindings cols"
psql service=fieldlink -c "\d export.partition_bindings" 2>&1
echo "###### partition_bindings rows"
psql service=fieldlink -x -c "select * from export.partition_bindings" 2>&1
echo "###### db privs"
psql service=fieldlink -Atc "select current_user, current_database(), version()" 2>&1
psql service=fieldlink -Atc "select table_schema,table_name,table_type from information_schema.tables" 2>&1 | head
psql service=fieldlink -Atc "select routine_schema,routine_name from information_schema.routines where routine_schema not in ('pg_catalog','information_schema')" 2>&1 | head -20
RSH
echo DONE_A3
