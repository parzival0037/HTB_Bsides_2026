set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'RSH'
set +e
CA=$HOME/.local/share/keplerops/ca.crt
B="Authorization: Bearer fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b"
U=https://support.keplerops.test:8443
echo "=== openapi probes"
for p in /openapi.json /api/openapi.json /docs /api/docs /api/routes /routes /metrics /health /api/health /api/customers/SUP-2841 /api/jobs /api/exports; do
  echo -n "-- $p "; curl -sS -m 10 -H "$B" --cacert "$CA" -o /tmp/o -w "%{http_code} " "$U$p"; head -c 300 /tmp/o; echo
done
echo "=== tenant probes (POST create)"
for t in ARWC arwc ARWC-019 TEN-ARWC-019 TEN-ARWC-047 SUP-2841 EXP-2841 CRR-OG2 CUST-ARWC-019 ARWC-01 PART-ARWC-01 part-arwc-01 TEN-ARWC ARWC01 customer-019 019; do
  echo -n "-- $t "; curl -sS -m 10 -X POST -H "$B" -H "Content-Type: application/json" --cacert "$CA" -d '{"connector_revision":"FLK-7.4.2"}' -o /tmp/o -w "%{http_code} " "$U/api/customers/$t/diagnostics"; head -c 400 /tmp/o; echo
done
RSH
