set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'CA=$HOME/.local/share/keplerops/ca.crt
echo "=== pivot check"
curl -sS -m 10 --socks5-hostname 127.0.0.1:1080 -k -o /dev/null -w "%{http_code}\n" https://source.keplerops.test/ 2>&1
echo "=== client ref"
curl -sS -m 20 -k https://delivery.keplerops.test:8443/.well-known/fieldkest-client; echo
echo "=== agent-side pivot from range box check (skip)"
' 2>&1 | tail -40
