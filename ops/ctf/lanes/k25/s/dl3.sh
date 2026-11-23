CA=$HOME/k25/ca.crt; P="--socks5-hostname 127.0.0.1:1080"; B=https://delivery.keplerops.test:8443
A="Authorization: Bearer fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b"
U="rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
for hdr in "bearer" "basic"; do
  echo "########## $hdr"
  if [ $hdr = bearer ]; then H=(-H "$A"); else H=(-u "$U"); fi
  echo "--- meta"; curl -sS $P --cacert $CA -m 20 "${H[@]}" -w '\n[%{http_code}]\n' "$B/api/package-meta/fieldlink-connector" | head -c 2500
  echo "--- release"; curl -sS $P --cacert $CA -m 20 "${H[@]}" -w '\n[%{http_code}]\n' "$B/api/releases/REL-FLK-6.9.8-ARCHIVE" | head -c 1500
  echo "--- reconcile"; curl -sS $P --cacert $CA -m 20 "${H[@]}" -H 'Content-Type: application/json' -d '{"tenant":"TEN-ARWC-047","version":"7.4.2"}' -w '\n[%{http_code}]\n' "$B/api/reconcile/tenant-package" | head -c 1500
done
