set +e
P="curl -sS -m 8 --socks5-hostname 127.0.0.1:1080 -k"
B="Authorization: Bearer fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b"
D=https://delivery.keplerops.test:8443
S=https://support.keplerops.test:8443
echo "=== delivery root/paths ==="
for p in / /api/inspections /api/package-meta/fieldlink-connector /api/customers /api/orders; do printf '%-40s ' "$p"; $P -H "$B" -o /tmp/f -w '%{http_code} ' "$D$p"; head -c 220 /tmp/f | tr '\n' ' '; echo; done
echo "=== support client ==="
for p in /api/handovers/current /api/customers/TEN-ARWC-047/diagnostics /api/customers/TEN-RILL-022/diagnostics; do printf '%-46s ' "$p"; $P -H "$B" -o /tmp/g -w '%{http_code} ' "$S$p"; head -c 260 /tmp/g | tr '\n' ' '; echo; done
