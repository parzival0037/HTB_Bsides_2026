#!/bin/bash
set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=10 -i /home/cinder/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$S 'set +e
echo "== dump"; cat ~/w09/company-history.dump
echo "== workspace tables"
psql service=fieldlink -Atc "select schemaname||E\x27.\x27||tablename from pg_tables where schemaname in (\x27workspace\x27,\x27support\x27,\x27export\x27) order by 1;" 2>&1
echo "== support tables data"
for t in $(psql service=fieldlink -Atc "select tablename from pg_tables where schemaname=\x27support\x27;"); do echo "--- $t"; psql service=fieldlink -c "select * from support.$t limit 20;" 2>&1 | head -30; done
echo DONE_R5' 2>&1
