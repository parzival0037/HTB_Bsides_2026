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
done
python3 - <<'PY'
import re,html
for i in range(1,6):
    s=open('/tmp/tk%d.html'%i,errors='replace').read()
    m=re.search(r'<title>(.*?)</title>',s,re.S)
    title=html.unescape(m.group(1)).strip() if m else '?'
    t=re.sub(r'<(script|style)[^>]*>.*?</\1>','',s,flags=re.S)
    t=re.sub(r'<br\s*/?>','\n',t)
    t=re.sub(r'</(p|div|tr|td|li|h\d)>','\n',t)
    t=re.sub(r'<[^>]+>',' ',t)
    t=html.unescape(t)
    t=re.sub(r'[ \t]+',' ',t)
    t=re.sub(r'\n\s*\n+','\n',t)
    print('='*30,'TICKET',i,title)
    # print interesting lines only
    kw=re.compile(r'EXP-|SCHED|dataset|revision|FLAG\{|tenant|TEN-|partition|export|diagnostic|asset|connector',re.I)
    for line in t.split('\n'):
        line=line.strip()
        if line and kw.search(line) and len(line)<400:
            print(' ',line)
PY
RSH
