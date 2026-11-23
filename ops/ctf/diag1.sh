set +e
P="curl -sS -m 10 --socks5-hostname 127.0.0.1:1080 -k"
B="Authorization: Bearer fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b"
S=https://support.keplerops.test:8443
echo "=== create diagnostic TEN-ARWC-047 ==="
$P -H "$B" -H 'Content-Type: application/json' -X POST -d '{"connector_revision":"FLK-7.4.2"}' "$S/api/customers/TEN-ARWC-047/diagnostics" | head -c 500; echo
echo "=== create diagnostic TEN-RILL-022 ==="
$P -H "$B" -H 'Content-Type: application/json' -X POST -d '{"connector_revision":"FLK-7.4.1-RILL"}' "$S/api/customers/TEN-RILL-022/diagnostics" | head -c 500; echo
