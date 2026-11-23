set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'RSH'
set +e
CA=$HOME/.local/share/keplerops/ca.crt
U=https://support.keplerops.test
rm -f /tmp/cj
curl -sS -m 15 -c /tmp/cj "$U/scp/login.php" --cacert "$CA" -o /tmp/lp.html
echo "=== form block"
python3 - <<'PY'
import re
s=open('/tmp/lp.html',errors='replace').read()
for m in re.finditer(r'<form[^>]*>.*?</form>',s,re.S):
    print(re.sub(r'\n\s*',' ',m.group(0))[:1500])
PY
echo "=== post login"
curl -sS -m 15 -b /tmp/cj -c /tmp/cj -i -X POST "$U/scp/login.php" --cacert "$CA" \
 --data-urlencode "userid=maya.ranscombe" --data-urlencode "passwd=sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk" --data "do=scplogin" --data "submit=Log+In" -o /tmp/lr.html
head -20 /tmp/lr.html
echo "=== again with -L"
rm -f /tmp/cj2
curl -sS -m 20 -L -c /tmp/cj2 -b /tmp/cj2 "$U/scp/login.php" --cacert "$CA" \
 --data-urlencode "userid=maya.ranscombe" --data-urlencode "passwd=sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk" --data "do=scplogin" --data "submit=Log+In" -o /tmp/lr2.html -w "final=%{url_effective} code=%{http_code}\n"
grep -io "invalid login\|Welcome\|Dashboard\|Log Out\|tickets.php" /tmp/lr2.html | sort -u | head
echo "=== tickets with cj2"
curl -sS -m 15 -b /tmp/cj2 "$U/scp/tickets.php" --cacert "$CA" -o /tmp/t.html -w "code=%{http_code}\n"
python3 - <<'PY'
import re,html
s=open('/tmp/t.html',errors='replace').read()
print(len(s))
for m in re.finditer(r'tickets\.php\?id=(\d+)',s)  :
    print('id',m.group(1))
for m in re.finditer(r'subject[^>]*>(.*?)<',s,re.S|re.I):
    print('subj',html.unescape(m.group(1)).strip()[:80])
PY
RSH
