set +e
P="curl -sS -m 8 --socks5-hostname 127.0.0.1:1080 -k"
echo "=== route fuzz on connector ==="
for path in /handover /handovers /relay /relays /customer /customers /tenants /api/handover /api/relay /v1 /v1/handover /client-reference /fieldkest-client /.well-known /docs/client /openapi /healthz /ready /metrics /debug /admin; do
  code=$($P -o /tmp/c3.out -w '%{http_code}' "https://connector.arwc.test$path")
  [ "$code" != "404" ] && { echo "$path -> $code"; head -c 200 /tmp/c3.out; echo; }
done
echo "=== ssh to connector host ==="
ssh -o BatchMode=yes -o ConnectTimeout=6 -o StrictHostKeyChecking=no rowan-dev 'timeout 5 bash -c "exec 3<>/dev/tcp/10.77.60.20/22; head -c 60 <&3"' 2>&1 | head -3
ssh -o BatchMode=yes -o ConnectTimeout=6 rowan-dev 'ssh -o BatchMode=yes -o ConnectTimeout=5 -o StrictHostKeyChecking=no rowan@10.77.60.20 "id" 2>&1 | head -3'
