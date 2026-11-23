set +e
P="--socks5-hostname 127.0.0.1:1080"
CA=/tmp/ca.crt
echo "=== pivot test ==="
curl -sS -m 10 $P -k --cacert $CA https://source.keplerops.test/ -o /dev/null -w "%{http_code}\n"
echo "=== connector well-known ==="
curl -sS -m 15 $P -k -i https://connector.arwc.test/.well-known/fieldkest-client | head -60
echo "=== connector root ==="
curl -sS -m 15 $P -k -i https://connector.arwc.test/ | head -40
echo "=== poll ==="
curl -sS -m 15 $P -k -i -X POST https://connector.arwc.test/api/fieldlink/packages/poll -H 'Content-Type: application/json' -d '{}' | head -40
echo "=== receipt 7.4.2 ==="
curl -sS -m 15 $P -k -i https://connector.arwc.test/api/fieldlink/packages/7.4.2/receipt | head -40
