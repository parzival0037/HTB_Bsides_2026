#!/bin/bash
printf 'api\nhealth\nfoo\napi/fieldlink\n' > /tmp/wl2.txt
gobuster dir -u https://connector.arwc.test -w /tmp/wl2.txt -k -t 4 --timeout 8s --proxy socks5://127.0.0.1:1080 -b 404 --no-error 2>&1 | tail -20
