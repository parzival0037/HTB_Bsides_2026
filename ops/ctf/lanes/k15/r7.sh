set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'RSH'
set +e
CA=$HOME/.local/share/keplerops/ca.crt
U=https://support.keplerops.test
rm -f /tmp/cj
curl -sS -m 15 -c /tmp/cj "$U/scp/login.php" --cacert "$CA" -o /tmp/lp.html
echo "=== login form fields"; grep -o 'name="[a-z_]*"' /tmp/lp.html | sort -u | tr '\n' ' '; echo
curl -sS -m 15 -b /tmp/cj -c /tmp/cj -X POST "$U/scp/login.php" --cacert "$CA" \
 --data-urlencode "userid=maya.ranscombe" --data-urlencode "pass=sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk" -o /tmp/lr.html -w "login code=%{http_code}\n"
grep -io "invalid\|error\|Welcome\|Dashboard\|Log Out" /tmp/lr.html | sort -u | head
echo "=== tickets.php"
curl -sS -m 15 -b /tmp/cj "$U/scp/tickets.php" --cacert "$CA" -o /tmp/t.html -w "code=%{http_code}\n"
grep -o 'tickets.php?id=[0-9]*' /tmp/t.html | sort -u | tr '\n' ' '; echo
echo "=== ticket ids + subjects"
python3 - <<'PY'
import re,html
s=open('/tmp/t.html',encoding='utf8',errors='replace').read()
for m in re.finditer(r'href="tickets\.php\?id=(\d+)"[^>]*>(.*?)</a>',s,re.S):
    t=re.sub('<[^>]+>','',m.group(2)); print(m.group(1), html.unescape(t).strip()[:90])
PY
echo "=== SUP-2841 search"
curl -sS -m 20 -b /tmp/cj "$U/scp/tickets.php?a=search&query=SUP-2841" --cacert "$CA" -o /tmp/ts.html -w "code=%{http_code}\n"
grep -o 'tickets.php?id=[0-9]*' /tmp/ts.html | sort -u | tr '\n' ' '; echo
RSH
