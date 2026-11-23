#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
C="curl -sS $P -k -m 25 -c /tmp/osc -b /tmp/osc"
rm -f /tmp/osc
$C -o /tmp/osp -w 'loginpage:%{http_code}\n' https://support.keplerops.test/scp/login.php
grep -oiE '<form[^>]*>|name="[^"]+"|csrf[^>]*' /tmp/osp | head -12
CSRF=$(grep -oP 'name="__CSRF_token__" value="\K[^"]+' /tmp/osp | head -1); echo "csrf=$CSRF"
$C -o /tmp/osl -w 'login:%{http_code} redir=%{redirect_url}\n' --data-urlencode "userid=maya.ranscombe" --data-urlencode "passwd=sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk" --data-urlencode "__CSRF_token__=$CSRF" --data-urlencode "dologin=Log In" "https://support.keplerops.test/scp/login.php"
grep -oiE 'Error[^<]{0,120}|Incorrect|Dashboard|open tickets|Ticket' /tmp/osl | head -6
$C -o /tmp/ost -w 'tickets:%{http_code}\n' "https://support.keplerops.test/scp/tickets.php?a=search&keywords=Vale"
python3 - <<'PY'
import re,html
s=open('/tmp/ost',errors='replace').read()
t=re.sub(r'<(script|style)[^>]*>.*?</\1>','',s,flags=re.S|re.I)
t=re.sub(r'<[^>]+>',' ',t); t=html.unescape(t)
t='\n'.join(l.strip() for l in t.splitlines() if l.strip())
print(t[:2500])
PY
