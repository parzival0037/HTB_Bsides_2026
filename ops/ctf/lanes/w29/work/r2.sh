#!/bin/bash
set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=10 -i /home/cinder/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$S 'set +e
echo "== home"; ls -la ~
echo "== aws cfg"; cat ~/.aws/config ~/.aws/credentials 2>/dev/null
echo "== find docs"; find ~ -maxdepth 5 -type f \( -iname "*alloc*" -o -iname "*plan*" -o -iname "*export*" -o -iname "*tariff*" -o -iname "*cairn*" -o -iname "*crr*" -o -iname "*RPT*" -o -iname "*.csv" \) 2>/dev/null | head -60
echo "== psql tables"
psql service=fieldlink -c "\dn" -c "\dt *.*" 2>&1 | head -80
echo "== s3"
aws --endpoint-url https://objects.keplerops.test s3 ls 2>&1 | head
aws --endpoint-url https://objects.keplerops.test s3 ls s3://fieldlink-exports 2>&1 | head -30
echo DONE_R2' 2>&1
