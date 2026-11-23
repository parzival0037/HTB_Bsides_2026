set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'RSH'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
echo "===KUBE==="
kubectl get ns 2>&1 | head -10; echo ---; kubectl -n fieldlink get pods,svc,secrets 2>&1 | head -20
echo "===PG==="
PGPASSFILE=/home/rowan/.pgpass psql "service=fieldlink" -c '\dn' -c '\dt' 2>&1 | head -40
echo "===S3==="
aws --endpoint-url https://objects.keplerops.test s3 ls s3://fieldlink-exports 2>&1 | head -10
echo "===NPM==="
cd /tmp && npm whoami 2>&1 | head -3; npm view @keplerops/fieldlink-connector versions --json 2>&1 | head -5
echo "===HTTP ENDPOINTS==="
for u in https://source.keplerops.test/api/v1/version https://ci.keplerops.test/api/json https://review.keplerops.test/.well-known/fieldkest-client https://preview.keplerops.test/health https://preview.keplerops.test/version https://staff.keplerops.test/ https://support.keplerops.test/scp/ https://assistant.keplerops.test/ https://llm.keplerops.test/api/tags https://indexer.keplerops.test/ https://ca.keplerops.test/ https://identity.keplerops.test/realms/keplerops https://delivery.keplerops.test:8443/.well-known/fieldkest-client https://connector.arwc.test/ ; do
  echo -n "$u -> "; curl -sS -m 6 -k -o /dev/null -w '%{http_code}\n' "$u" 2>&1
done
RSH
