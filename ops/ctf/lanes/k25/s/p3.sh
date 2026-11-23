CA=$HOME/k25/ca.crt; P="--socks5-hostname 127.0.0.1:1080"
A="Authorization: Bearer fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b"
B=https://support.keplerops.test:8443
echo "=== GET job"
curl -sS $P --cacert $CA -m 40 -H "$A" -w '\nHTTP:%{http_code}\n' "$B/api/diagnostics/DIAG-ARWC-B608C281"
echo "=== GET handover"
curl -sS $P --cacert $CA -m 40 -H "$A" -w '\nHTTP:%{http_code}\n' "$B/api/handovers/current"
