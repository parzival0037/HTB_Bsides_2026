set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'RSH'
set +e
CA=$HOME/.local/share/keplerops/ca.crt
B="Authorization: Bearer fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b"
U=https://support.keplerops.test:8443
for p in /api/exports /api/exports/EXP-2841 /api/exports/EXP-2841/definition /api/export-jobs /api/export-jobs/EXP-2841 /api/jobs/EXP-2841 /api/diagnostics/EXP-2841/definition /api/customers/TEN-ARWC-047/exports /api/customers/TEN-ARWC-047/export /api/collections /api/datasets /api/partitions /api/diagnostics/DIAG-ARWC-0214CB78/definition /api/diagnostics/DIAG-ARWC-0214CB78/package /api/diagnostics/DIAG-ARWC-0214CB78/handover /api/handovers/EXP-2841 /api/handovers/DIAG-ARWC-0214CB78; do
  code=$(curl -sS -m 8 -H "$B" --cacert "$CA" -o /tmp/o -w "%{http_code}" "$U$p")
  echo "-- GET $p -> $code $(head -c 200 /tmp/o)"
done
echo "=== no auth root paths"
for p in /api/diagnostics/DIAG-ARWC-0214CB78 /api/handovers/current; do
  code=$(curl -sS -m 8 --cacert "$CA" -o /tmp/o -w "%{http_code}" "$U$p"); echo "-- noauth GET $p -> $code $(head -c 150 /tmp/o)"
done
echo "=== k8s can-i"
kubectl auth can-i --list 2>&1 | head -40
echo "=== svc"
kubectl -n fieldlink get svc 2>&1 | head -10
RSH
