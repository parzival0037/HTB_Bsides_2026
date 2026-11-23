#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
CA=/tmp/keplerca.crt
rm -f /tmp/cj
curl -gsS $P --cacert $CA -m 25 -c /tmp/cj "https://support.keplerops.test/scp/login.php" -o /tmp/l.html
TOK=$(grep -o 'name="__CSRFToken__" value="[^"]*"' /tmp/l.html | head -1 | sed 's/.*value="//;s/"//')
echo "tok=$TOK"
curl -gsS $P --cacert $CA -m 25 -c /tmp/cj -b /tmp/cj -D /tmp/h.txt \
 --data-urlencode "__CSRFToken__=$TOK" --data-urlencode "do=scplogin" \
 --data-urlencode "userid=maya.ranscombe" --data-urlencode "passwd=sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk" \
 --data-urlencode "submit=Log In" \
 "https://support.keplerops.test/scp/login.php" -o /tmp/a.html
head -5 /tmp/h.txt
grep -oE '(Access Denied|Invalid|incorrect|error|Valid)[^<]{0,80}' /tmp/a.html | head -5
echo "=== index ==="
curl -gsS $P --cacert $CA -m 25 -b /tmp/cj -D /tmp/h2.txt "https://support.keplerops.test/scp/index.php" -o /tmp/i.html
head -3 /tmp/h2.txt
grep -oE '<title>[^<]*' /tmp/i.html
grep -oE '(tickets\.php[^"'"'"' ]*|href="[^"]*id=[0-9]+[^"]*")' /tmp/i.html | sort -u | head -30
echo "=== open tickets ==="
curl -gsS $P --cacert $CA -m 25 -b /tmp/cj "https://support.keplerops.test/scp/tickets.php?a=open" -o /tmp/t.html
grep -oE 'tickets\.php\?id=[0-9]+' /tmp/t.html | sort -u
grep -oE '<a[^>]*class="Subject"[^>]*>[^<]*|no rows|No tickets' /tmp/t.html | head -20
