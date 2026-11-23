set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'RSH'
set +e
CA=$HOME/.local/share/keplerops/ca.crt
B="Authorization: Bearer fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b"
U=https://support.keplerops.test:8443
p(){ echo "--- POST $1 $2"; curl -sS -m 20 -X POST -H "$B" -H "Content-Type: application/json" --cacert "$CA" -d "$2" -w " [%{http_code}]" "$U$1" | head -c 2000; echo; }
p /api/customers/TEN-ARWC-019/diagnostics '{"connector_revision":"FLK-7.4.2"}'
p /api/customers/TEN-ARWC-019/diagnostics '{"connector_revision":"FLK-7.3.1"}'
p /api/customers/TEN-ARWC-019/diagnostics '{"connector_revision":"6.9.8"}'
p /api/customers/TEN-ARWC-019/diagnostics '{}'
p /api/customers/TEN-OTHER-001/diagnostics '{"connector_revision":"FLK-7.3.1"}'
RSH
