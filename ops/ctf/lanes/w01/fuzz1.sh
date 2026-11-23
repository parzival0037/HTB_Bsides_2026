#!/bin/bash
set -x
curl -sSLo /tmp/wl.txt https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/raft-small-words.txt || exit 1
wc -l /tmp/wl.txt
gobuster dir -u https://connector.arwc.test -w /tmp/wl.txt -k -t 20 --timeout 8s --proxy socks5://127.0.0.1:1080 -b 404 -q 2>&1 | head -60
echo "=== with /api prefix"
gobuster dir -u https://connector.arwc.test/api -w /tmp/wl.txt -k -t 20 --timeout 8s --proxy socks5://127.0.0.1:1080 -b 404 -q 2>&1 | head -60
echo "=== 2 levels: /api/fieldlink"
gobuster dir -u https://connector.arwc.test/api/fieldlink -w /tmp/wl.txt -k -t 20 --timeout 8s --proxy socks5://127.0.0.1:1080 -b 404 -q 2>&1 | head -60
