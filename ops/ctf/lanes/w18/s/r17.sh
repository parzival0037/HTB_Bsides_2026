#!/bin/bash
KO="-i ~/.ssh/keplerops-foothold -p 2222 -o StrictHostKeyChecking=no -o ConnectTimeout=10"
ssh $KO rowan@10.50.13.180 '
export PGPASSWORD=lobf9Jt0SBW433in6wUVlkixnQreh5K-Z1LjbTofrqY
echo "=== dbs"; psql -h data.keplerops.test -U rowan_data -d fieldlink_data -tAc "select datname from pg_database" 2>&1
echo "=== schemas"; psql -h data.keplerops.test -U rowan_data -d fieldlink_data -tAc "select schema_name from information_schema.schemata" 2>&1
echo "=== tables"; psql -h data.keplerops.test -U rowan_data -d fieldlink_data -tAc "select table_schema||\".\"||table_name from information_schema.tables where table_schema not in (\"pg_catalog\",\"information_schema\")" 2>&1 | head -80
' 2>&1
