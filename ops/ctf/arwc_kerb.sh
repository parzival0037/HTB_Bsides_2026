set +e
R=/home/rowan/.local/share/keplerops/ca.crt
echo "=== SPNEGO to the relay ==="
ssh -o BatchMode=yes rowan-dev "KRB5CCNAME=FILE:/tmp/evan.ccache curl -sS -m 12 --negotiate -u : --cacert $R -o /tmp/a -w 'GET diag [%{http_code}] ' https://connector.arwc.test/api/fieldlink/diagnostics; head -c 300 /tmp/a; echo"
ssh -o BatchMode=yes rowan-dev "KRB5CCNAME=FILE:/tmp/evan.ccache curl -sS -m 12 --negotiate -u : --cacert $R -X POST -H 'Content-Type: application/json' -d '{}' -o /tmp/a2 -w 'POST diag [%{http_code}] ' https://connector.arwc.test/api/fieldlink/diagnostics; head -c 300 /tmp/a2; echo"
echo "=== relay with client cert (mTLS) ==="
ssh -o BatchMode=yes rowan-dev "for s in evan.calderoux maya.ranscombe; do printf '%-18s ' \$s; curl -sS -m 12 --cacert $R --cert /tmp/\$s.crt --key /tmp/\$s.key -o /tmp/a3 -w '[%{http_code}] ' https://connector.arwc.test/api/fieldlink/diagnostics; head -c 200 /tmp/a3; echo; done"
echo "=== other SPNs for supplier admin ==="
U=https://staff.keplerops.test/api/archive/delegation/probe
for spn in "HTTP/connector.arwc.test@KEPLEROPS.TEST" "HTTP/cloud-api.keplerops.test@KEPLEROPS.TEST" "HTTP/workloads.keplerops.test@KEPLEROPS.TEST"; do
  printf '%-46s ' "$spn"
  ssh -o BatchMode=yes rowan-dev "curl -sS -m 12 --cacert $R --cert /tmp/evan.calderoux.crt --key /tmp/evan.calderoux.key -X POST -H 'Content-Type: application/json' -d '{\"spn\":\"$spn\"}' $U" | head -c 220; echo
done
