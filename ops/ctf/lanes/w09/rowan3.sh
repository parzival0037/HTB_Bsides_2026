#!/bin/bash
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=10 rowan-dev"
$S 'set -x
echo "===== partition_bindings"
psql service=fieldlink -c "select * from export.partition_bindings;" 2>&1
echo "===== all relations incl partitions"
psql service=fieldlink -c "select n.nspname,c.relname,c.relkind,pg_get_userbyid(c.relowner) owner_ FROM pg_class c join pg_namespace n on n.oid=c.relnamespace where n.nspname not in ('"'"'pg_catalog'"'"','"'"'information_schema'"'"','"'"'pg_toast'"'"') order by 1,2;" 2>&1 | head -100
echo "===== support tables"
psql service=fieldlink -c "\dt support.*" 2>&1
echo "===== workspace tables"
psql service=fieldlink -c "\dt workspace.*" 2>&1
echo "===== S3 backups recursive"
aws --endpoint-url https://objects.keplerops.test s3 ls --recursive s3://fieldlink-exports/ 2>&1 | head -100
echo "===== kubectl"
kubectl get all -n fieldlink 2>&1 | head -40
kubectl get secrets,cm -n fieldlink 2>&1 | head -40
' 2>&1 | tail -250
