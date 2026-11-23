#!/bin/bash
T=/tmp/w29; mkdir -p $T
echo "--- tmux ---"; tmux ls 2>&1
echo "--- pivot check ---"
curl -sS --socks5-hostname 127.0.0.1:1080 -k -o /dev/null -w '%{http_code}\n' https://source.keplerops.test/ 2>&1
echo "--- connector.arwc.test root ---"
curl -sS --socks5-hostname 127.0.0.1:1080 -k -i https://connector.arwc.test/ 2>&1 | head -40
echo "--- connector /.well-known ---"
for p in /.well-known/fieldkest-client /api /health /api/health; do
  echo "== $p"; curl -sS --socks5-hostname 127.0.0.1:1080 -k -i "https://connector.arwc.test$p" 2>&1 | head -20
done
echo "--- dns ---"
getent hosts connector.arwc.test 2>&1
