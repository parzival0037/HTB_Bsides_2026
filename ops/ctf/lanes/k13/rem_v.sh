set +e
E=https://objects.keplerops.test
A="aws --endpoint-url $E"
echo "== auth random buckets baseline =="
for b in zzq-random-9182 qqq-nope-abc totallyfakebucket9; do
  echo "-- $b"; $A s3api head-bucket --bucket $b 2>&1 | head -3
  $A s3 ls "s3://$b" 2>&1 | head -3
done
echo "== auth candidate buckets head =="
for b in fieldkest-workspaces fieldlink-exports support-exports support-export fieldkest-exports fieldkest-support fieldkest-support-exports fieldkest-handovers fieldkest-archive fieldkest-records fieldkest-workloads fieldkest-identities workspace-exports fieldkest-data fieldkest-customer-records; do
  out=$($A s3api head-bucket --bucket $b 2>&1 | tr '\n' ' ')
  echo "-- $b -> ${out:-OK(200)}"
done
