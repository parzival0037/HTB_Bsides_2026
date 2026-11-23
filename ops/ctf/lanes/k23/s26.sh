#!/bin/bash
SSH="ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -p 2222 rowan@rowan-dev"
$SSH 'set -x; cat ~/.aws/config 2>/dev/null; cat ~/.aws/credentials 2>/dev/null; echo ---; aws --endpoint-url https://objects.keplerops.test s3 ls 2>&1 | head -30; echo ---; aws --endpoint-url https://objects.keplerops.test s3 ls s3://fieldlink-exports 2>&1 | head -30' 2>&1 | grep -v Warning | tail -60
