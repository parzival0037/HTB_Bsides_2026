set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'RSH'
set +e
CA=$HOME/.local/share/keplerops/ca.crt
U=https://support.keplerops.test
rm -f /tmp/cj
curl -sS -m 15 -c /tmp/cj "$U/scp/login.php" --cacert "$CA" -o /tmp/lp.html
TOK=$(grep -o '__CSRFToken__" value="[a-f0-9]*' /tmp/lp.html | sed 's/.*value="//')
curl -sS -m 20 -b /tmp/cj -c /tmp/cj -X POST "$U/scp/login.php" --cacert "$CA" \
 -H "Referer: $U/scp/login.php" --data-urlencode "__CSRFToken__=$TOK" --data "do=scplogin" \
 --data-urlencode "userid=maya.ranscombe" --data-urlencode "passwd=sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk" \
 --data "submit=Log+In" -o /dev/null
for id in 1 2 3 4 5; do
  curl -sS -m 20 -b /tmp/cj "$U/scp/tickets.php?id=$id" --cacert "$CA" -o /tmp/tk$id.html
  echo "===== TICKET $id"
  python3 - "$id" <<'PY'
import re,sys,html
i=sys.argv[1]
s=open('/tmp/tk%s.html'%i,errors='replace').read()
m=re.search(r'<title>(.*?)</title>',s,re.S)
print('TITLE:',html.unescape(m.group(1)).strip() if m else '?')
# strip scripts/styles/tags
t=re.sub(r'<(script|style)[^>]*>.*?</\1>','',s,flags=re.S)
t=re.sub(r'<br\s*/?>','\n',t)
t=re.sub(r'</(p|div|tr|td|li|h\d)>','\n',t)
t=re.sub(r'<[^>]+>',' ',t)
t=html.unescape(t)
t=re.sub(r'[ \t]+',' ',t)
t=re.sub(r'\n\s*\n+','\n',t)
print(t[:4000])
PY
done
RSH
