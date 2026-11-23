CA=$HOME/k25/ca.crt; P="--socks5-hostname 127.0.0.1:1080"; B=https://delivery.keplerops.test:8443
A="Authorization: Bearer fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b"
U="rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
echo "=== well-known (no auth)"; curl -sS $P --cacert $CA -m 15 -w '\n[%{http_code}]\n' "$B/.well-known/fieldkest-client"
echo "=== well-known bearer"; curl -sS $P --cacert $CA -m 15 -H "$A" -w '\n[%{http_code}]\n' "$B/.well-known/fieldkest-client" | head -c 3000
echo "=== well-known basic"; curl -sS $P --cacert $CA -m 15 -u "$U" -w '\n[%{http_code}]\n' "$B/.well-known/fieldkest-client" | head -c 3000
echo "=== root"; curl -sS $P --cacert $CA -m 15 -w '\n[%{http_code}]\n' "$B/" | head -c 600
