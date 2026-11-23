set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'RSH'
set +e
CA=$HOME/.local/share/keplerops/ca.crt
B="Authorization: Bearer fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b"
U=https://support.keplerops.test:8443
g(){ echo "--- $1"; curl -sS -m 20 -H "$B" --cacert "$CA" -w " [%{http_code}]" "$U$1" | head -c 1500; echo; }
g /
g /api
g /api/customers
g /api/customers/TEN-ARWC-019
g /api/customers/TEN-ARWC-019/diagnostics
g /api/diagnostics
g /api/diagnostics/EXP-2841
g /api/diagnostics/JOB-215D690E28A8
g /api/handovers
RSH
