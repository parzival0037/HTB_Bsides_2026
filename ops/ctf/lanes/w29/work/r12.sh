#!/bin/bash
set +e
P="--socks5-hostname 127.0.0.1:1080 -k -sS -m 20"
for p in / /.well-known/fieldkest-client /.well-known/fieldkest-relay /api /api/ /health /version /robots.txt; do
 echo "=== $p"; curl $P -i "https://connector.arwc.test$p" | head -30
done
echo DONE_R12
