#!/bin/bash
SSH="ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -p 2222 rowan@rowan-dev"
echo "== kubectl auth"
$SSH 'kubectl auth can-i --list -n fieldlink 2>&1 | head -40; echo ---; kubectl get pods -n fieldlink 2>&1 | head -20; echo ---; kubectl get all -n fieldlink 2>&1 | head -40' 2>&1 | grep -v Warning
echo "== osTicket hrefs"
P="--socks5-hostname 127.0.0.1:1080"; K="-k -sS -m 30"; S=https://support.keplerops.test
CJ=/tmp/cj.txt; rm -f $CJ
curl $K $P -c $CJ $S/scp/login.php -o /tmp/login.html
TOKEN=$(grep -o 'name="__CSRFToken__" value="[^"]*"' /tmp/login.html | sed 's/.*value="//;s/"$//')
curl $K $P -b $CJ -c $CJ -X POST $S/scp/login.php --data-urlencode "__CSRFToken__=$TOKEN" \
  --data-urlencode "userid=maya.ranscombe" --data-urlencode "passwd=sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk" \
  --data-urlencode "do=scplogin" -o /dev/null
curl $K $P -b $CJ "$S/scp/tickets.php?id=1" -o /tmp/t1.html
echo "-- hrefs"
grep -o 'href="[^"]*"' /tmp/t1.html | sort -u | head -60
echo "-- attach mentions"
grep -io '.\{80\}attach.\{120\}' /tmp/t1.html | head -10
echo "-- print view"
curl $K $P -b $CJ "$S/scp/tickets.php?id=1&a=print" -o /tmp/t1p.html -w "print %{http_code} %{size_download}\n"
grep -o 'href="[^"]*"' /tmp/t1p.html | sort -u | head -40
