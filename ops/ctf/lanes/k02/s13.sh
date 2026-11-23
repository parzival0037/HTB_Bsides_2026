#!/bin/bash
ssh -i ~/.ssh/keplerops-foothold -o StrictHostKeyChecking=no -o ConnectTimeout=10 -p 2222 rowan@10.50.13.180 '
cd /tmp/k02npm
npm pack @keplerops/fieldlink-connector@7.4.3-cinder.rset1 2>&1 | tail -3
mkdir -p c && tar xzf keplerops-fieldlink-connector-7.4.3-cinder.rset1.tgz -C c
find c -type f
echo "===== package.json ====="; cat c/package/package.json
echo "===== README ====="; cat c/package/README.md
echo "===== limits.json ====="; cat c/package/limits.json
echo "===== index.js ====="; cat c/package/index.js
echo "===== grep FLAG ====="; grep -r "FLAG{" c 2>/dev/null
echo "===== npm view ====="; npm view @keplerops/fieldlink-connector@7.4.3-cinder.rset1 2>&1 | head -40
echo "===== s3 backups ====="; aws --endpoint-url https://objects.keplerops.test s3 ls --recursive s3://fieldlink-exports/backups/ 2>&1 | head -20
' 2>&1 | tail -120
