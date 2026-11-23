#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080 -k -sS --max-time 20"
echo "=== connector.arwc.test root"
curl $P -D- https://connector.arwc.test/ 2>&1 | head -60
echo "=== well-known client"
curl $P https://connector.arwc.test/.well-known/fieldkest-client 2>&1 | head -80
echo "=== dns"
getent hosts connector.arwc.test source.keplerops.test
