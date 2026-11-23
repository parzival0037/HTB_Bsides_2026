#!/bin/bash
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=10 rowan-dev"
$S 'set -x
mkdir -p ~/w09
cd ~/w09
aws --endpoint-url https://objects.keplerops.test s3 cp s3://fieldlink-exports/backups/company-history.dump . 2>&1
ls -la
file company-history.dump
strings -n 6 company-history.dump | head -100
echo "===== support grants"
psql service=fieldlink -c "select grantee,table_schema,table_name,privilege_type from information_schema.role_table_grants where table_schema in ('"'"'support'"'"','"'"'export'"'"');" 2>&1
echo "===== try selects"
psql service=fieldlink -c "select * from support.customer_migration_history limit 20;" 2>&1
psql service=fieldlink -c "select * from support.customer_records limit 20;" 2>&1
psql service=fieldlink -c "select current_user, session_user;" 2>&1
' 2>&1 | tail -200
