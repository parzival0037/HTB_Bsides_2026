CA=$HOME/k25/ca.crt; P="--socks5-hostname 127.0.0.1:1080"
A="Authorization: Bearer fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b"
U="rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
B=https://staff.keplerops.test
echo "=== service-directory bearer"
curl -sS $P --cacert $CA -m 25 -H "$A" -w '\nHTTP:%{http_code}\n' "$B/api/service-directory"
echo "=== service-directory basic"
curl -sS $P --cacert $CA -m 25 -u "$U" -w '\nHTTP:%{http_code}\n' "$B/api/service-directory"
for s in SUP-2841 CRR-OG2 ARWC TEN-ARWC-019 TEN-ARWC-047 SUP-K-2841; do
  echo "=== archive handovers/$s bearer"
  curl -sS $P --cacert $CA -m 25 -H "$A" -w '\nHTTP:%{http_code}\n' "$B/api/archive/handovers/$s"
done
