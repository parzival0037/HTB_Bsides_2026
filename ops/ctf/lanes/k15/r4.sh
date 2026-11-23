set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'RSH'
set +e
CA=$HOME/.local/share/keplerops/ca.crt
echo "=== cloud-api well-known"
curl -sS -m 10 --cacert $CA https://cloud-api.keplerops.test/.well-known/fieldkest-client; echo
echo "=== workloads well-known"
curl -sS -m 10 --cacert $CA https://workloads.keplerops.test/.well-known/fieldkest-client; echo
echo "=== workload well-known"
curl -sS -m 10 --cacert $CA https://workload.keplerops.test/.well-known/fieldkest-client; echo
echo "=== indexer well-known"
curl -sS -m 10 --cacert $CA https://indexer.keplerops.test/.well-known/fieldkest-client; echo
echo "=== kubectl auth"
kubectl auth can-i --list 2>&1 | head -40
echo "=== kubectl ns"
kubectl get ns 2>&1 | head -20
echo "=== kubectl fieldlink visible"
kubectl -n fieldlink get all 2>&1 | head -20
echo "=== kubectl api-resources"
kubectl api-resources --namespaced=true 2>&1 | head -40
echo "=== download dump"
export AWS_CA_BUNDLE=$CA
aws --endpoint-url https://objects.keplerops.test s3 cp s3://fieldlink-exports/backups/company-history.dump /tmp/ch.dump 2>&1 | tail -2
ls -la /tmp/ch.dump; file /tmp/ch.dump
echo "=== dump TOC"
pg_restore -l /tmp/ch.dump 2>&1 | head -80
RSH
