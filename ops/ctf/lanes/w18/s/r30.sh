#!/bin/bash
KO="ssh -i $HOME/.ssh/keplerops-foothold -p 2222 -o StrictHostKeyChecking=no -o ConnectTimeout=10 rowan@10.50.13.180"
$KO '
cat ~/.pg_service.conf; echo ---; cat ~/.pgpass
export PGPASSWORD=lobf9Jt0SBW433in6wUVlkixnQreh5K-Z1LjbTofrqY
Q(){ psql -h data.keplerops.test -U rowan_data -d fieldlink_data -tAc "$1" 2>&1; }
echo "===== tables all schema"; Q "select table_schema||chr(46)||table_name from information_schema.tables order by 1"
echo "===== columns workspace"; Q "select table_name,column_name,data_type from information_schema.columns where table_schema not in (chr(112)||chr(103)||chr(95)||chr(99)||chr(97)||chr(116)||chr(97)||chr(108)||chr(111)||chr(103),chr(105)||chr(110)||chr(102)||chr(111)||chr(114)||chr(109)||chr(97)||chr(116)||chr(105)||chr(111)||chr(110)||chr(95)||chr(115)||chr(99)||chr(104)||chr(101)||chr(109)||chr(97)) order by 1,2"
echo "===== tables/cols matching"; Q "select table_schema,table_name,column_name from information_schema.columns where table_name ~* chr(97)||chr(114)||chr(119)||chr(99)||chr(124)||chr(116)||chr(97)||chr(103)||chr(124)||chr(112)||chr(114)||chr(111)||chr(99)||chr(101)||chr(115)||chr(115)||chr(124)||chr(111)||chr(98)||chr(115)||chr(101)||chr(114)||chr(118)||chr(124)||chr(114)||chr(101)||chr(103)||chr(105)||chr(115)||chr(116)||chr(101)||chr(114)||chr(124)||chr(104)||chr(105)||chr(115)||chr(116)||chr(124)||chr(115)||chr(101)||chr(114)||chr(105)||chr(101)||chr(115)||chr(124)||chr(116)||chr(101)||chr(110)||chr(97)||chr(110)||chr(116)"
echo "===== roles/db"; Q "select datname from pg_database"
echo "===== partition_bindings"; Q "select * from export.partition_bindings limit 20"
' 2>&1
