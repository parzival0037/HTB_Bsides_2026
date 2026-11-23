#!/bin/bash
SSH="ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -i $HOME/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$SSH 'bash -s' <<'INNER'
export PGPASSWORD=lobf9Jt0SBW433in6wUVlkixnQreh5K-Z1LjbTofrqY
psql -h data.keplerops.test -U rowan_data -d fieldlink_data -c '\dn' -c '\dt *.*' 2>&1 | head -100
echo "===== all tables in non-system schemas"
psql -h data.keplerops.test -U rowan_data -d fieldlink_data -Atc "select schemaname||'.'||tablename from pg_tables where schemaname not in ('pg_catalog','information_schema') order by 1;" 2>&1
INNER
