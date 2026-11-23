set +e
ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=15 rowan-dev 'bash -s' <<'RSH'
set +e
export AWS_PAGER=""
A="aws --endpoint-url https://objects.keplerops.test --no-verify-ssl"
echo "===== buckets"
$A s3 ls 2>&1 | head -20
echo "===== fieldlink-exports recursive"
$A s3 ls s3://fieldlink-exports/ --recursive 2>&1 | head -80
echo "===== fieldkest-exports recursive"
$A s3 ls s3://fieldkest-exports/ --recursive 2>&1 | head -80
RSH
