#!/bin/bash
SSH="ssh -i $HOME/.ssh/keplerops-foothold -o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8 rowan-dev"
$SSH 'export PGPASSWORD=lobf9Jt0SBW433in6wUVlkixnQreh5K-Z1LjbTofrqY
echo "== databases"; psql -h 10.77.50.11 -U rowan_data -d fieldlink_data -Atc "select datname from pg_database" 2>&1 | head -20
echo "== roles"; psql -h 10.77.50.11 -U rowan_data -d fieldlink_data -Atc "select rolname from pg_roles" 2>&1 | head -20
echo "== schemas in fieldlink_data"; psql -h 10.77.50.11 -U rowan_data -d fieldlink_data -Atc "select table_schema||\".\"||table_name from information_schema.tables where table_schema not in (\"pg_catalog\",\"information_schema\") order by 1" 2>&1 | head -40
echo "== cat pg_service"; cat ~/.pg_service.conf' 2>&1
