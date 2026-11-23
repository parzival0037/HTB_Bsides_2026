set +e
P="curl -sS -m 12 --socks5-hostname 127.0.0.1:1080 -k"
B="Authorization: Bearer fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b"
S=https://support.keplerops.test:8443
J=DIAG-ARWC-1C48FE7C
echo "=== GET job ==="; $P -H "$B" "$S/api/diagnostics/$J"; echo
echo "=== PUT package (probe shape) ==="
$P -H "$B" -H 'Content-Type: application/json' -X PUT -d '{}' "$S/api/diagnostics/$J/package" | head -c 400; echo
echo "=== POST deliver (probe) ==="
$P -H "$B" -H 'Content-Type: application/json' -X POST -d '{}' "$S/api/diagnostics/$J/deliver" | head -c 400; echo
