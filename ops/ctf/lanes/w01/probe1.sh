#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
echo "=== pivot test source ==="
curl -sS $P -k --max-time 20 https://source.keplerops.test/ -o /dev/null -w '%{http_code}\n'
echo "=== connector root ==="
curl -sS $P -k --max-time 25 -i https://connector.arwc.test/ | head -60
echo "=== connector 8443? ==="
curl -sS $P -k --max-time 15 -i https://connector.arwc.test:8443/ | head -20
echo "=== http? ==="
curl -sS $P --max-time 15 -i http://connector.arwc.test/ | head -20
