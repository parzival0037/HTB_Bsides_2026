#!/bin/bash
set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=10 -i /home/cinder/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$S bash -s <<'REMOTE'
set +e
echo "== support.customer_migration_history"
psql service=fieldlink -c 'select * from support.customer_migration_history;'
echo "== support.customer_records"
psql service=fieldlink -c 'select * from support.customer_records;'
echo "== workspace tables"
psql service=fieldlink -c "select schemaname,tablename from pg_tables where schemaname in ('workspace','export');"
echo "== workspace rows"
for t in $(psql service=fieldlink -Atc "select tablename from pg_tables where schemaname='workspace';"); do echo "--- $t"; psql service=fieldlink -c "select * from workspace.$t limit 50;"; done
echo "== all s3 objects"
aws --endpoint-url https://objects.keplerops.test s3api list-objects-v2 --bucket fieldlink-exports --query 'Contents[].[Key,Size,LastModified]' --output text 2>&1 | head -50
echo "== bucket list"
aws --endpoint-url https://objects.keplerops.test s3api list-buckets --query 'Buckets[].[Name]' --output text 2>&1
echo DONE_R6
REMOTE
