set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'RSH'
set +e
export PGPASSWORD=lobf9Jt0SBW433in6wUVlkixnQreh5K-Z1LjbTofrqY
P="psql -h data.keplerops.test -U rowan_data -d fieldlink_data -At"
echo "=== partition_bindings"
$P -c "select * from export.partition_bindings" 2>&1 | head -40
echo "=== partition_bindings cols"
$P -c "select column_name,data_type from information_schema.columns where table_schema='export' and table_name='partition_bindings'" 2>&1 | head -40
echo "=== customer_records"
$P -c "select * from support.customer_records" 2>&1 | head -40
echo "=== customer_migration_history"
$P -c "select * from support.customer_migration_history" 2>&1 | head -40
echo "=== workspace tables"
$P -c "select schemaname||'.'||tablename from pg_tables where schemaname='workspace'" 2>&1
echo "=== S3 recursive"
export AWS_CA_BUNDLE=$HOME/.local/share/keplerops/ca.crt
aws --endpoint-url https://objects.keplerops.test s3 ls --recursive s3://fieldlink-exports 2>&1 | head -80
echo "=== delivery well-known"
CA=$HOME/.local/share/keplerops/ca.crt
curl -sS -m 10 --cacert $CA "https://delivery.keplerops.test:8443/.well-known/fieldkest-client" ; echo
echo "=== support handover bearer"
curl -sS -m 15 --cacert $CA -H "Authorization: Bearer fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b" "https://support.keplerops.test:8443/api/handovers/current"; echo
echo "=== support well-known"
curl -sS -m 10 --cacert $CA -H "Authorization: Bearer fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b" "https://support.keplerops.test:8443/.well-known/fieldkest-client"; echo
echo "=== objects well-known/local files"
ls -la ~/.aws 2>&1; cat ~/.aws/config 2>&1; cat ~/.aws/credentials 2>&1
echo "=== support client profile"
cat ~/.config/fieldlink/support-client.json 2>&1 | head -60
RSH
