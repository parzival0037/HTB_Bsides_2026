#!/bin/bash
KO="-i ~/.ssh/keplerops-foothold -p 2222 -o StrictHostKeyChecking=no -o ConnectTimeout=10"
ssh $KO rowan@10.50.13.180 'export PGPASSWORD=lobf9Jt0SBW433in6wUVlkixnQreh5K-Z1LjbTofrqY
for db in fieldlink_data fieldlink fieldlink_identity fieldlink_staff; do
 echo "########## DB $db"
 psql -h data.keplerops.test -U rowan_data -d $db -tAc "select table_schema||chr(46)||table_name from information_schema.tables where table_schema not in (chr(112)||chr(103)||chr(95)||chr(99)||chr(97)||chr(116)||chr(97)||chr(108)||chr(111)||chr(103), chr(105)||chr(110)||chr(102)||chr(111)||chr(114)||chr(109)||chr(97)||chr(116)||chr(105)||chr(111)||chr(110)||chr(95)||chr(115)||chr(99)||chr(104)||chr(101)||chr(109)||chr(97)) order by 1" 2>&1 | head -60
done
' 2>&1
