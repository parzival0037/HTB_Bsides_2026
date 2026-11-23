#!/bin/bash
S="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$S 'cat > /tmp/pg3.sh' <<'EOS'
#!/bin/bash
Q(){ psql service=fieldlink -A -F'|' -c "$1" 2>&1; }
echo "### tables"
Q "select table_schema, table_name from information_schema.tables where table_schema not in ('pg_catalog','information_schema') order by 1,2;"
echo "### columns"
Q "select table_schema, table_name, column_name, data_type from information_schema.columns where table_schema not in ('pg_catalog','information_schema') order by 1,2,ordinal_position;"
echo "### support.customer_records"
Q "select * from support.customer_records;"
echo "### support.customer_migration_history"
Q "select * from support.customer_migration_history;"
EOS
chmod +x /tmp/pg3.sh
$S 'bash /tmp/pg3.sh' 2>&1 | head -160
