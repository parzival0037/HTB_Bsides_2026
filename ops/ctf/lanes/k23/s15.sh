#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
K="-k -sS -m 30"
S=https://support.keplerops.test
CJ=/tmp/cj.txt; rm -f $CJ
curl $K $P -c $CJ $S/scp/login.php -o /tmp/login.html -w "loginpage %{http_code} %{size_download}\n"
echo "-- form fields"; grep -o 'name="[a-zA-Z_]*"' /tmp/login.html | sort -u
TOKEN=$(grep -o 'name="__CSRFToken__" value="[^"]*"' /tmp/login.html | sed 's/.*value="//;s/"$//')
echo "TOKEN=$TOKEN"
curl $K $P -b $CJ -c $CJ -X POST $S/scp/login.php \
  --data-urlencode "__CSRFToken__=$TOKEN" \
  --data-urlencode "username=maya.ranscombe" \
  --data-urlencode "password=sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk" \
  --data-urlencode "dst=scp/index.php" \
  --data-urlencode "do=scp/login" \
  -D /tmp/hdr.txt -o /tmp/post.html -w "POST %{http_code} %{size_download}\n"
grep -i '^location\|^set-cookie' /tmp/hdr.txt
echo "-- cookies"; cat $CJ
echo "-- tickets page"
curl $K $P -b $CJ $S/scp/tickets.php -o /tmp/tickets.html -w "tickets %{http_code} %{size_download}\n"
grep -o 'tickets.php?id=[0-9]*' /tmp/tickets.html | sort -u | head -20
grep -o '<title>[^<]*' /tmp/tickets.html
