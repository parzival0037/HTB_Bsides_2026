set +e
ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=15 rowan-dev 'bash -s' <<'RSH'
set +e
export AWS_PAGER=""
A="aws --endpoint-url https://objects.keplerops.test --no-verify-ssl"
for K in EXP-2841-rowan/PART-ARWC-01-rev10.json EXP-2841/PART-ARWC-01-rev10.json PART-ARWC-01-rev10.json EXP-2841-maya/PART-ARWC-01-rev10.json EXP-2841-rowan/PART-ARWC-01-rev6.json; do
  echo "===== fieldkest-exports/$K"
  $A s3 cp "s3://fieldkest-exports/$K" - 2>&1 | grep -v InsecureRequestWarning | grep -v warnings.warn | head -c 1200; echo
done
echo "===== company-history.dump"
$A s3 cp s3://fieldlink-exports/backups/company-history.dump - 2>&1 | grep -v InsecureRequestWarning | grep -v warnings.warn | head -c 5000; echo
RSH
