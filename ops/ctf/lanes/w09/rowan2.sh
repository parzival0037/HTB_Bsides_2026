#!/bin/bash
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=10 rowan-dev"
$S 'set -x
echo "===== identity-access"
cat ~/work/identity-access.md
echo "===== connector repo wiki files"
cd ~/work/fieldlink-connector && git log --oneline -20 2>&1 | head; git branch -a 2>&1
cat README.md docs/report-provider.md review/FLK-7.4.2.md tests/test_crr_og2_report.py
echo "===== connector-archive README"
cat ~/repos/connector-archive/connector-archive/README.md 2>/dev/null
echo "===== connector-archive files"
find ~/repos/connector-archive/connector-archive -type f -printf "%10s %p\n" | sort -k2
echo "===== postgres schemas"
psql service=fieldlink -c "\dn+" 2>&1
echo "===== postgres tables"
psql service=fieldlink -c "select table_schema,table_name from information_schema.tables where table_schema not in ('"'"'pg_catalog'"'"','"'"'information_schema'"'"') order by 1,2;" 2>&1 | head -100
echo "===== pg service conf"
cat ~/.pg_service.conf ~/.pgpass
echo "===== S3"
aws --endpoint-url https://objects.keplerops.test s3 ls 2>&1
aws --endpoint-url https://objects.keplerops.test s3 ls s3://fieldlink-exports 2>&1 | head -50
' 2>&1 | tail -300
