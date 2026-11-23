set +e
P="curl -sS -m 8 --socks5-hostname 127.0.0.1:1080 -k"
D=https://delivery.keplerops.test:8443
U=rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo
for auth in "-u $U" "-H Authorization:Bearer\ fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b"; do
  echo "### auth=$auth"
  for p in /api/package-meta/fieldlink-connector /api/inspections /api/orders /api/customers/TEN-ARWC-047/inspections; do
    printf '  %-46s ' "$p"
    $P $auth -o /tmp/d -w '%{http_code} ' "$D$p"; head -c 200 /tmp/d | tr '\n' ' '; echo
  done
done
