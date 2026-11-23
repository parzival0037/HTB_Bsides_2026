#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
show(){ echo "########## $1"; curl -sS $P -k --max-time 20 -i "$1" | head -c 4000; echo; }
show https://support.keplerops.test:8443/api/handovers/current
show https://connector.arwc.test/api/fieldlink/packages/7.4.2/receipt
show https://connector.arwc.test/api/fieldlink/packages/7.4.2/activate
show https://delivery.keplerops.test:8443/api/package-meta/fieldlink-connector
show https://delivery.keplerops.test:8443/api/releases/7.4.2
