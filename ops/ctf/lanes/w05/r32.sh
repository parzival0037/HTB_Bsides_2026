#!/bin/bash
H='ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ConnectTimeout=8 -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180'
$H 'for db in fieldlink fieldlink_identity fieldlink_staff fieldlink_data; do
 echo "########## $db"
 psql "service=fieldlink dbname=$db" -Atc "select n.nspname||E\x27.\x27||c.relname||E\x27:\x27||c.relkind from pg_class c join pg_namespace n on n.oid=c.relnamespace where c.relkind in (\x27r\x27,\x27v\x27,\x27m\x27,\x27p\x27) and n.nspname not like \x27pg_%\x27 order by 1" 2>&1 | head -60
done'
