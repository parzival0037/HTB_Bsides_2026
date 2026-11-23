#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
J=/tmp/osjar
rm -f $J
C="curl -sS $P -k -m 25 -c $J -b $J"
$C -o /tmp/osp -w 'loginpage:%{http_code}\n' https://support.keplerops.test/scp/login.php
TOK=$(grep -oP 'name="__CSRFToken__" value="\K[^"]+' /tmp/osp | head -1); echo "tok=$TOK"
$C -o /tmp/osl -D /tmp/osh -w 'login:%{http_code}\n' -L --data-urlencode "userid=maya.ranscombe" --data-urlencode "passwd=sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk" --data-urlencode "__CSRFToken__=$TOK" --data-urlencode "do=signin" --data-urlencode "submit=Sign+In" "https://support.keplerops.test/scp/login.php"
grep -iE 'HTTP/|location:' /tmp/osh | head
echo "--- body snippet"; python3 - <<'PY'
import re,html
s=open('/tmp/osl',errors='replace').read()
t=re.sub(r'<(script|style)[^>]*>.*?</\1>','',s,flags=re.S|re.I); t=re.sub(r'<[^>]+>',' ',t); t=html.unescape(t)
print('\n'.join(l.strip() for l in t.splitlines() if l.strip())[:600])
PY
for u in "tickets.php?a=search&keywords=Vale" "tickets.php?a=search&keywords=starter" "tickets.php?a=search&keywords=onboard" "tickets.php" "tickets.php?status=closed"; do
 echo "##### $u"; $C -o /tmp/ost -w '%{http_code}\n' "https://support.keplerops.test/scp/$u"
 python3 - <<'PY'
import re,html
s=open('/tmp/ost',errors='replace').read()
for m in re.finditer(r'href="tickets\.php\?id=(\d+)"[^>]*>([^<]{3,90})',s):
    print(m.group(1), html.unescape(m.group(2)).strip())
PY
done
