set +e
E=https://objects.keplerops.test
A="aws --endpoint-url $E"
echo "== auth list fieldkest-workspaces =="
$A s3 ls s3://fieldkest-workspaces --recursive 2>&1
echo "== auth versions =="
$A s3api list-object-versions --bucket fieldkest-workspaces 2>&1 | head -60
echo "== auth buckets =="
$A s3 ls 2>&1
echo "== candidate buckets with creds =="
for b in support-exports support-export fieldlink-support support fieldkest-support exports notebooks fieldkest-exports backups; do
  echo "-- $b"; $A s3 ls "s3://$b" --recursive 2>&1 | head -5
done
echo "== bucket acl/policy fieldkest-workspaces =="
$A s3api get-bucket-policy --bucket fieldkest-workspaces 2>&1 | head -40
$A s3api get-bucket-acl --bucket fieldkest-workspaces 2>&1 | head -30
echo "== try protected keys =="
for k in records/CUSTREC-047-R6 records/CUSTREC-047-R6.json support/CUSTREC-047-R6.json records/support.json protected/records.json records.json; do
  echo "-- $k"; curl -sSk -m 6 -o /tmp/pk -w '%{http_code}\n' "$E/fieldkest-workspaces/$k"; head -c 300 /tmp/pk; echo
done
