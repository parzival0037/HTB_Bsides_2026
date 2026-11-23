set +e
P="curl -sS -m 10 --socks5-hostname 127.0.0.1:1080 -k"
echo "=== client reference (source-tools) ==="
$P https://source-tools.keplerops.test:8443/.well-known/fieldkest-client | head -c 1200; echo
echo "=== delivery with staff mTLS ==="
ssh -o BatchMode=yes rowan-dev 'R=/home/rowan/.local/share/keplerops/ca.crt; for p in /api/package-meta/fieldlink-connector /api/inspections; do printf "%-46s " $p; curl -sS -m 10 --cacert $R --cert /tmp/evan.calderoux.crt --key /tmp/evan.calderoux.key -o /tmp/dd -w "[%{http_code}] " https://delivery.keplerops.test:8443$p; head -c 200 /tmp/dd; echo; done'
