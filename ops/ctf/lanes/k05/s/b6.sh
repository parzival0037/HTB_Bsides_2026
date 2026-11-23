set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'export PGPASSWORD=lobf9Jt0SBW433in6wUVlkixnQreh5K-Z1LjbTofrqY
P="psql -h data.keplerops.test -U rowan_data -d fieldlink_data -At"
echo "=== customer_records"; $P -c "\d support.customer_records"; $P -c "select * from support.customer_records" | head -40
echo; echo "=== migration_history"; $P -c "\d support.customer_migration_history"; $P -c "select * from support.customer_migration_history" | head -40
echo; echo "=== partition_bindings"; $P -c "select * from export.partition_bindings" | head -40' 2>&1 | tail -120
