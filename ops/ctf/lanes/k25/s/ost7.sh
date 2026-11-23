CA=$HOME/k25/ca.crt; P="--socks5-hostname 127.0.0.1:1080"; B=https://support.keplerops.test; CK=/tmp/k25-ck.txt
curl -sS $P --cacert $CA -m 25 -b $CK -o /tmp/k25-tk.html "$B/scp/tickets.php"
echo "=== links"
grep -oE 'tickets\.php\?id=[0-9]+[^"]*' /tmp/k25-tk.html | sort -u
echo "=== table rows"
python3 - <<'PY'
import re
h=open('/tmp/k25-tk.html').read()
# strip tags within rows
for m in re.finditer(r'<tr[^>]*>(.*?)</tr>', h, re.S):
    row=m.group(1)
    txt=re.sub(r'<[^>]+>',' ',row)
    txt=re.sub(r'\s+',' ',txt).strip()
    if 'SUP-' in txt or 'ESC-' in txt or 'REV-' in txt: print(txt[:300])
PY
