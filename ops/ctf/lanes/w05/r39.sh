#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
J=/tmp/kbjar; rm -f $J
C="curl -sS $P -k -m 20 -c $J -b $J"
$C -o /tmp/kbl https://workboard.keplerops.test/login
TOK=$(grep -oP 'name="csrf_token" value="\K[^"]+' /tmp/kbl | head -1)
$C -o /dev/null --data-urlencode "username=maya.ranscombe" --data-urlencode "password=sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk" --data-urlencode "csrf_token=$TOK" "https://workboard.keplerops.test/?controller=AuthController&action=check"
for u in "board/1" "list/1" "projects"; do
 echo "###### /$u"; $C -o /tmp/pg -w '%{http_code}\n' "https://workboard.keplerops.test/$u"
 python3 - <<'PY'
import re,html
s=open('/tmp/pg',errors='replace').read()
for m in re.finditer(r'href="(/task/show/\d+[^"]*)"[^>]*>(.*?)</a>',s,re.S):
    t=re.sub(r'<[^>]+>','',m.group(2)); t=html.unescape(t).strip()
    print("TASK",m.group(1),'::',t[:120])
for m in re.finditer(r'href="(/project/[^"]*)"[^>]*>(.*?)</a>',s,re.S):
    t=re.sub(r'<[^>]+>','',m.group(2)); t=html.unescape(t).strip()
    if t: print("PROJ",m.group(1),'::',t[:120])
PY
done
echo "###### cert/ca probes"
for h in cert.keplerops.test ca.keplerops.test; do
 for p in "" api v1 health roots root ca certs enroll enrollment sign issue api/v1/certs api/v1/enroll .well-known/acme-directory .well-known/fieldkest-client; do
  c=$(curl -sS $P -k -m 8 -o /tmp/c.$$ -w '%{http_code}' "https://$h/$p")
  [ "$c" != "404" ] && echo "[$c] $h/$p :: $(head -c 200 /tmp/c.$$|tr -d '\n')"
 done
done
rm -f /tmp/c.$$
