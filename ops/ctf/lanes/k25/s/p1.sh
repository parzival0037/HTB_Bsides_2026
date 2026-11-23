CA=$HOME/k25/ca.crt; P="--socks5-hostname 127.0.0.1:1080"
A="Authorization: Bearer fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b"
B=https://support.keplerops.test:8443
echo "=== GET /api/diagnostics/JOB-215D690E28A8"
curl -sS $P --cacert $CA -m 30 -H "$A" -H 'Accept: application/json' -w '\nHTTP:%{http_code}\n' "$B/api/diagnostics/JOB-215D690E28A8"
echo "=== GET /api/customers/TEN-ARWC-019"
curl -sS $P --cacert $CA -m 30 -H "$A" -w '\nHTTP:%{http_code}\n' "$B/api/customers/TEN-ARWC-019"
echo "=== GET /api/customers/TEN-ARWC-019/dossier"
curl -sS $P --cacert $CA -m 30 -H "$A" -w '\nHTTP:%{http_code}\n' "$B/api/customers/TEN-ARWC-019/dossier"
echo "=== GET /api/customers/TEN-ARWC-047"
curl -sS $P --cacert $CA -m 30 -H "$A" -w '\nHTTP:%{http_code}\n' "$B/api/customers/TEN-ARWC-047"
echo "=== OPTIONS customers diagnostics"
curl -sS $P --cacert $CA -m 30 -X OPTIONS -D - -o /dev/null -H "$A" "$B/api/customers/TEN-ARWC-019/diagnostics" | head -20
