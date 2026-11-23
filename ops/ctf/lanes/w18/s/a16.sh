#!/bin/bash
KO="ssh -i $HOME/.ssh/keplerops-foothold -p 2222 -o StrictHostKeyChecking=no -o ConnectTimeout=10 rowan@10.50.13.180"
$KO '
echo "===== aws config"; ls -la ~/.aws; cat ~/.aws/config ~/.aws/credentials 2>/dev/null
echo "===== s3 ls buckets"; aws --endpoint-url https://objects.keplerops.test s3 ls 2>&1 | head -20
echo "===== s3 ls fieldlink-exports"; aws --endpoint-url https://objects.keplerops.test s3 ls s3://fieldlink-exports 2>&1 | head -40
echo "===== local helper"; ps aux | grep -iE "8701|helper|inspect" | grep -v grep | head
echo "===== helper root"; curl -sS -m 8 -i http://127.0.0.1:8701/ 2>&1 | head -20
echo "===== helper sample"; curl -sS -m 8 --fail --form sample=@~/work/samples/FK-SAMPLE-017.json http://127.0.0.1:8701/api/inspection-summary 2>&1 | head -c 1500; echo
' 2>&1
