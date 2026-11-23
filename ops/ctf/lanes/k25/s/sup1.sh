CA=$HOME/k25/ca.crt; P="--socks5-hostname 127.0.0.1:1080"
A="Authorization: Bearer fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b"
B=https://support.keplerops.test:8443
echo "=== handovers/current"
curl -sS $P --cacert $CA -m 30 -H "$A" -H 'Accept: application/json' -w '\nHTTP:%{http_code}\n' "$B/api/handovers/current"
echo "=== without auth"
curl -sS $P --cacert $CA -m 30 -w '\nHTTP:%{http_code}\n' "$B/api/handovers/current"
