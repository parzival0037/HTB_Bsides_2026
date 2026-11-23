set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'RSH'
set +e
CA=$HOME/.local/share/keplerops/ca.crt
B="Authorization: Bearer fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b"
U=https://support.keplerops.test:8443
g(){ echo "--- GET $1"; curl -sS -m 15 -H "$B" --cacert "$CA" -w " [%{http_code}]" "$U$1" | head -c 2500; echo; }
g /api/diagnostics/DIAG-ARWC-0214CB78
g /api/customers/TEN-ARWC-047
g /api/customers/TEN-ARWC-047/diagnostics
g /api/handovers/current
echo "=== gitea repos"
A="Authorization: Basic $(printf 'rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo' | base64 -w0)"
curl -sS -m 20 -H "$A" --cacert "$CA" "https://source.keplerops.test/api/v1/user/repos?limit=50" | python3 -c "import json,sys;d=json.load(sys.stdin);[print(r['full_name'],'|',r.get('description','')) for r in d]" 2>&1 | head -60
RSH
