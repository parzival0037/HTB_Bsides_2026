#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
B=https://identity.keplerops.test
echo "###### /admin/"
curl -sS $P -k -m 15 -i "$B/admin/" | head -40
echo "###### /admin follow"
curl -sS $P -k -m 15 -L "$B/admin/" -o /tmp/ad.html -w '%{http_code} %{url_effective} %{size_download}\n'
head -c 3000 /tmp/ad.html
echo; echo "###### assets"
grep -oE '(src|href)="[^"]+"' /tmp/ad.html | sort -u | head -30
