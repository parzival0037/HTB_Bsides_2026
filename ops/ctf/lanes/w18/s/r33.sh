#!/bin/bash
KO="ssh -i $HOME/.ssh/keplerops-foothold -p 2222 -o StrictHostKeyChecking=no -o ConnectTimeout=10 rowan@10.50.13.180"
$KO '
export PGPASSWORD=lobf9Jt0SBW433in6wUVlkixnQreh5K-Z1LjbTofrqY
for db in arwc arwc_data arwc_process ot ot_history historian process process_data fieldlink_process fieldlink_historian fieldlink_ot fieldlink_data export postgres; do
 r=$(timeout 6 psql -h data.keplerops.test -U rowan_data -d "$db" -tAc "select 1" 2>&1 | head -1)
 echo "$db => $r"
done
echo "===== roles"; psql -h data.keplerops.test -U rowan_data -d fieldlink_data -tAc "select rolname from pg_roles" 2>&1 | head -30
echo "===== current grants"; psql -h data.keplerops.test -U rowan_data -d fieldlink_data -tAc "select table_schema,table_name,privilege_type from information_schema.role_table_grants where grantee=current_user" 2>&1 | head -30
echo "===== dblist with privileges"; psql -h data.keplerops.test -U rowan_data -d fieldlink_data -tAc "select datname,datacl from pg_database" 2>&1 | head
' 2>&1
