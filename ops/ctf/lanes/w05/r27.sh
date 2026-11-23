#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
J=/tmp/osjar; rm -f $J
C="curl -sS $P -k -m 25 -c $J -b $J"
$C -o /tmp/osp https://support.keplerops.test/scp/login.php
TOK=$(grep -oP 'name="__CSRFToken__" value="\K[^"]+' /tmp/osp | head -1)
$C -o /dev/null -L --data-urlencode "userid=maya.ranscombe" --data-urlencode "passwd=sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk" --data-urlencode "__CSRFToken__=$TOK" --data-urlencode "do=signin" "https://support.keplerops.test/scp/login.php"
for u in "tickets.php?status=open" "tickets.php?status=closed" "tickets.php?a=search&keywords=Mira" "tickets.php?a=search&keywords=account" "tickets.php?a=search&keywords=roster"; do
 echo "##### $u"
 $C -o /tmp/ost "https://support.keplerops.test/scp/$u"
 python3 - <<'PY'
import re,html
s=open('/tmp/ost',errors='replace').read()
s=re.sub(r'<(script|style)[^>]*>.*?</\1>','',s,flags=re.S|re.I)
# find ticket links with ids
ids=set(re.findall(r'tickets\.php\?id=(\d+)',s))
print("ticket ids:",sorted(ids,key=int))
for m in re.finditer(r'<a[^>]+href="tickets\.php\?id=(\d+)"[^>]*>(.*?)</a>',s,re.S):
    t=re.sub(r'<[^>]+>','',m.group(2)); t=html.unescape(t).strip()
    if t: print(" ",m.group(1),t[:120])
PY
done
