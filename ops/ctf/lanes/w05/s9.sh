#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
B=https://support.keplerops.test
echo "===== GET headers"
curl -sS $P -k -m 20 -D - -o /tmp/l.html "$B/scp/login.php" | head -20
echo "===== login form"
python3 - <<'PY'
import re
s=open("/tmp/l.html",errors="replace").read()
for m in re.finditer(r'<form[^>]*>',s): print(m.group(0))
for m in re.finditer(r'<input[^>]*>',s): print(m.group(0))
print("size",len(s))
PY
echo "===== attempt with cookie capture"
rm -f /tmp/j1
TOK=$(grep -oP 'name="__CSRFToken__" value="\K[^"]+' /tmp/l.html | head -1)
curl -sS $P -k -m 20 -c /tmp/j1 -b /tmp/j1 -o /tmp/l2.html -D - "$B/scp/login.php" | head -10
TOK2=$(grep -oP 'name="__CSRFToken__" value="\K[^"]+' /tmp/l2.html | head -1)
echo "tok1=$TOK tok2=$TOK2"
curl -sS $P -k -m 25 -c /tmp/j1 -b /tmp/j1 -o /tmp/p.html -D - \
  --data-urlencode "__CSRFToken__=$TOK2" --data-urlencode "do=signin" \
  --data-urlencode "username=maya.ranscombe" \
  --data-urlencode "password=sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk" \
  --data-urlencode "remember=1" "$B/scp/login.php" | head -20
echo "--- jar"; cat /tmp/j1 | grep -v '^#'; echo "--- body errors"
grep -oiP 'incorrect|invalid|error|locked|try again[^<]*' /tmp/p.html | sort -u | head
grep -oiP '<title>[^<]*' /tmp/p.html
