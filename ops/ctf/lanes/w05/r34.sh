#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
J=/tmp/kbjar; rm -f $J
C="curl -sS $P -k -m 20 -c $J -b $J"
$C -o /tmp/kbl https://workboard.keplerops.test/login
TOK=$(grep -oP 'name="csrf_token" value="\K[^"]+' /tmp/kbl | head -1)
$C -o /dev/null --data-urlencode "username=maya.ranscombe" --data-urlencode "password=sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk" --data-urlencode "csrf_token=$TOK" "https://workboard.keplerops.test/?controller=AuthController&action=check"
for u in "projects" "board/1" "list/1" "search?search=Vale" "?controller=SearchController&action=index&search=Vale" "?controller=SearchController&action=index&search=starter"; do
 echo "############ /$u"
 $C -o /tmp/pg -w '%{http_code}\n' "https://workboard.keplerops.test/$u"
 python3 - <<'PY'
import re,html
s=open('/tmp/pg',errors='replace').read()
s=re.sub(r'<(script|style)[^>]*>.*?</\1>','',s,flags=re.S|re.I)
for m in re.finditer(r'href="(/task/[^"]+|/project/[^"]+)"[^>]*>(.*?)</a>',s,re.S):
    t=re.sub(r'<[^>]+>','',m.group(2)); t=html.unescape(t).strip()
    if t: print(" ",m.group(1),'::',t[:100])
t=re.sub(r'<[^>]+>',' ',s); t=html.unescape(t)
t='\n'.join(l.strip() for l in t.splitlines() if l.strip())
print(t[:900])
PY
done
