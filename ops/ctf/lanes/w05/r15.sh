#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
echo "###### id root redirect"
curl -sS $P -k -m 12 -i https://id.keplerops.test/ | head -20
echo "###### get wordlist"
[ -s /tmp/wl.txt ] || curl -sSL -m 60 -o /tmp/wl.txt https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/raft-medium-directories.txt
[ -s /tmp/wl.txt ] || curl -sSL -m 60 -o /tmp/wl.txt https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/common.txt
wc -l /tmp/wl.txt
echo "###### gobuster connector"
gobuster dir -u https://connector.arwc.test -w /tmp/wl.txt -k -q --proxy socks5://127.0.0.1:1080 -t 20 --timeout 10s -b 404 --exclude-length 28 2>&1 | head -40
echo "###### gobuster id"
gobuster dir -u https://id.keplerops.test -w /tmp/wl.txt -k -q --proxy socks5://127.0.0.1:1080 -t 20 --timeout 10s -b 404 2>&1 | head -30
