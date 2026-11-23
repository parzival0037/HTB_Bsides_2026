set +e
P="curl -sS -m 8 --socks5-hostname 127.0.0.1:1080 -k"
for path in / /docs /openapi.json /api /api/v1 /health /status /.well-known/fieldkest-client /robots.txt; do
  printf '%-34s ' "$path"; code=$($P -o /tmp/c.out -w '%{http_code}' "https://connector.arwc.test$path"); echo -n "$code "; head -c 160 /tmp/c.out | tr '\n' ' '; echo
done
echo "=== with support bearer ==="
$P -H 'Authorization: Bearer fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b' https://connector.arwc.test/ | head -c 300; echo
echo "=== ssh banner on 60.20:22 ==="
timeout 4 bash -c 'exec 3<>/dev/tcp/10.77.60.20/22; head -c 80 <&3' 2>/dev/null || echo "no direct reach from kali"
ssh -o BatchMode=yes rowan-dev 'timeout 4 bash -c "exec 3<>/dev/tcp/10.77.60.20/22; head -c 80 <&3"' 2>&1 | head -2
