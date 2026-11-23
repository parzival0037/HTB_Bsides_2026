set +e
ssh -o BatchMode=yes rowan-dev 'psql service=fieldlink -c "\dt support.*" -c "\dt export.*" 2>&1 | head -20'
echo "=== support.customer_records ==="
ssh -o BatchMode=yes rowan-dev "psql service=fieldlink -c 'select * from support.customer_records limit 5' 2>&1 | head -20"
echo "=== support.customer_migration_history ==="
ssh -o BatchMode=yes rowan-dev "psql service=fieldlink -c 'select * from support.customer_migration_history limit 5' 2>&1 | head -20"
