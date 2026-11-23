#!/bin/bash
SSH="ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -p 2222 rowan@rowan-dev"
$SSH 'A="aws --endpoint-url https://objects.keplerops.test s3"; echo "== backups"; $A ls s3://fieldlink-exports/backups/ 2>&1 | head -40; echo "== recursive"; $A ls --recursive s3://fieldlink-exports/ 2>&1 | head -60; echo "== buckets acl"; aws --endpoint-url https://objects.keplerops.test s3api list-buckets 2>&1 | head -20' 2>&1 | grep -v Warning | head -80
