#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
J=/tmp/osjar; rm -f $J
C="curl -sS $P -k -m 25 -c $J -b $J"
$C -o /tmp/osp https://support.keplerops.test/scp/login.php
TOK=$(grep -oP 'name="__CSRFToken__" value="\K[^"]+' /tmp/osp | head -1)
$C -o /dev/null -L --data-urlencode "userid=maya.ranscombe" --data-urlencode "passwd=sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk" --data-urlencode "__CSRFToken__=$TOK" --data-urlencode "do=signin" "https://support.keplerops.test/scp/login.php"
for u in "users.php" "users.php?a=search&keywords=Vale" "kb.php" "kb.php?a=search&keywords=starter" "orgs.php"; do
 echo "##### $u"; $C -o /tmp/ost -w '%{http_code}\n' "https://support.keplerops.test/scp/$u"
 python3 - <<'PY'
import re,html
s=open('/tmp/ost',errors='replace').read()
s=re.sub(r'<(script|style)[^>]*>.*?</\1>','',s,flags=re.S|re.I)
t=re.sub(r'<[^>]+>',' ',s); t=html.unescape(t)
t='\n'.join(l.strip() for l in t.splitlines() if l.strip())
print(t[:1200])
PY
done
echo "###### workboard root"
curl -sS $P -k -m 20 -i https://workboard.keplerops.test/ | head -20
curl -sS $P -k -m 20 -L https://workboard.keplerops.test/ -o /tmp/kbl -w '%{http_code} %{url_effective}\n'
head -c 800 /tmp/kbl
