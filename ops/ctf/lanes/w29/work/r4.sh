#!/bin/bash
set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=10 -i /home/cinder/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$S 'set +e
echo "== w09 dir"; find ~/w09 -maxdepth 3 -type f -printf "%s %p\n" 2>/dev/null | head -40
echo "== results"; find ~/results -maxdepth 2 -printf "%y %s %p\n" 2>/dev/null | head -30
echo "== schemas tables"
psql service=fieldlink -c "select schemaname,tablename from pg_tables where schemaname not in (\"pg_catalog\",\"information_schema\") order by 1,2;" 2>&1 | head -60
echo "== export partition_bindings"
psql service=fieldlink -c "select * from export.partition_bindings;" 2>&1 | head -40
echo "== workspace tables"
psql service=fieldlink -c "select schemaname,tablename from pg_tables where schemaname=\"workspace\";" 2>&1 | head -40
echo "== s3 backups"
aws --endpoint-url https://objects.keplerops.test s3 ls s3://fieldlink-exports/backups/ --recursive 2>&1 | head -20
echo DONE_R4' 2>&1
