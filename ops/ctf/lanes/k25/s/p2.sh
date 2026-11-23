CA=$HOME/k25/ca.crt; P="--socks5-hostname 127.0.0.1:1080"
A="Authorization: Bearer fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b"
B=https://support.keplerops.test:8443
post() { echo "=== POST $1 body=$2"; curl -sS $P --cacert $CA -m 40 -X POST -H "$A" -H 'Content-Type: application/json' -d "$2" -w '\nHTTP:%{http_code}\n' "$B$1"; }
post /api/customers/TEN-ARWC-019/diagnostics '{"connector_revision":"FLK-7.4.2"}'
post /api/customers/TEN-ARWC-047/diagnostics '{"connector_revision":"FLK-7.4.2"}'
