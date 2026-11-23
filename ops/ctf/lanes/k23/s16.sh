#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
K="-k -sS -m 30"
S=https://support.keplerops.test
CJ=/tmp/cj.txt; rm -f $CJ
curl $K $P -c $CJ $S/scp/login.php -o /tmp/login.html
TOKEN=$(grep -o 'name="__CSRFToken__" value="[^"]*"' /tmp/login.html | sed 's/.*value="//;s/"$//')
grep -o '<form.\{0,400\}' /tmp/login.html
curl $K $P -b $CJ -c $CJ -X POST $S/scp/login.php \
  --data-urlencode "__CSRFToken__=$TOKEN" \
  --data-urlencode "userid=maya.ranscombe" \
  --data-urlencode "passwd=sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk" \
  --data-urlencode "do=scplogin" \
  -D /tmp/hdr.txt -o /tmp/post.html -w "POST %{http_code} %{size_download}\n"
grep -i '^location\|^set-cookie\|^HTTP' /tmp/hdr.txt
echo "-- tickets page"
curl $K $P -b $CJ $S/scp/tickets.php -o /tmp/tickets.html -w "tickets %{http_code} %{size_download}\n"
grep -o 'tickets.php?id=[0-9]*' /tmp/tickets.html | sort -u | head -20
grep -o '<title>[^<]*' /tmp/tickets.html
echo "-- search tickets"
curl $K $P -b $CJ "$S/scp/tickets.php?a=search&keywords=SUP" -o /tmp/t2.html -w "search %{http_code} %{size_download}\n"
grep -o 'tickets.php?id=[0-9]*' /tmp/t2.html | sort -u | head -20
