#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
T="Authorization: Bearer fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
echo "###### staff note"
for n in NOTE-SUP-2841-7 NOTE-SUP-2841-1 note-sup-2841-7; do
  echo "--- $n"; curl -sS $P -k -m 15 -H "$T" -w ' [%{http_code}]' "https://staff.keplerops.test/api/notes/$n" | head -c 1200; echo
done
echo "###### connector cert"
echo | openssl s_client -proxy 127.0.0.1:1080 -connect connector.arwc.test:443 -servername connector.arwc.test 2>/dev/null | openssl x509 -noout -subject -issuer -ext subjectAltName 2>/dev/null
echo "###### osticket login"
C="curl -sS $P -k -m 25 -c /tmp/osc -b /tmp/osc"
rm -f /tmp/osc
$C -o /tmp/osp -w 'loginpage:%{http_code}\n' https://support.keplerops.test/scp/login.php
CSRF=$(grep -oP 'name="__CSRF_token__" value="\K[^"]+' /tmp/osp | head -1); echo "csrf=$CSRF"
$C -o /tmp/osl -w 'login:%{http_code}\n' -L --data-urlencode "userid=maya.ranscombe" --data-urlencode "passwd=sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk" --data-urlencode "__CSRF_token__=$CSRF" --data-urlencode "dologin=Log In" "https://support.keplerops.test/scp/login.php"
grep -oiE 'error[^<]{0,100}|Dashboard|Tickets' /tmp/osl | head -5
$C -o /tmp/ost -w 'tickets:%{http_code}\n' "https://support.keplerops.test/scp/tickets.php?a=search&keywords=Vale"
python3 - <<'PY'
import re,html
s=open('/tmp/ost',errors='replace').read()
t=re.sub(r'<(script|style)[^>]*>.*?</\1>','',s,flags=re.S|re.I)
t=re.sub(r'<[^>]+>',' ',t); t=html.unescape(t)
t='\n'.join(l.strip() for l in t.splitlines() if l.strip())
print(t[:3000])
PY
