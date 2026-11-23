CA=$HOME/k25/ca.crt; P="--socks5-hostname 127.0.0.1:1080"; B=https://support.keplerops.test; CK=/tmp/k25-ck.txt
curl -sS $P --cacert $CA -m 25 -b $CK -o /tmp/k25-t1full.html "$B/scp/tickets.php?id=1"
echo "=== attachment-ish hrefs"
grep -oE '(href|src|action)="[^"]+"' /tmp/k25-t1full.html | grep -iE 'file|attach|download|view|get' | sort -u | head -40
echo "=== all text from Ticket Thread onward"
python3 - <<'PY'
import re
h=open('/tmp/k25-t1full.html',errors='replace').read()
i=h.find('Ticket Thread (')
h=h[i:]
body=re.sub(r'<script.*?</script>',' ',h,flags=re.S)
txt=re.sub(r'<[^>]+>','\n',body)
txt=re.sub(r'\n\s*\n+','\n',txt)
print('\n'.join(l.strip() for l in txt.split('\n') if l.strip())[:6000])
PY
