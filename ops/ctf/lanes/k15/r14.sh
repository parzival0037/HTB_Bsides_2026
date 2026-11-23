set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'RSH'
set +e
CA=$HOME/.local/share/keplerops/ca.crt
U=https://support.keplerops.test
rm -f /tmp/cj
curl -sS -m 15 -c /tmp/cj "$U/scp/login.php" --cacert "$CA" -o /tmp/lp.html
TOK=$(grep -o '__CSRFToken__" value="[a-f0-9]*' /tmp/lp.html | sed 's/.*value="//')
echo "token=$TOK"
curl -sS -m 20 -b /tmp/cj -c /tmp/cj -i -X POST "$U/scp/login.php" --cacert "$CA" \
 -H "Referer: $U/scp/login.php" -H "X-Requested-With: XMLHttpRequest" \
 --data-urlencode "__CSRFToken__=$TOK" --data "do=scplogin" \
 --data-urlencode "userid=maya.ranscombe" --data-urlencode "passwd=sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk" \
 --data "submit=Log+In" | head -30
echo "=== cookies"; cat /tmp/cj
echo "=== tickets"
curl -sS -m 15 -b /tmp/cj -c /tmp/cj "$U/scp/tickets.php" --cacert "$CA" -o /tmp/t.html -w "code=%{http_code}\n"
grep -io "invalid login\|access denied\|Welcome\|Log Out\|Logout" /tmp/t.html | sort -u | head
python3 - <<'PY'
import re,html
s=open('/tmp/t.html',errors='replace').read()
print('len',len(s))
for m in re.finditer(r'tickets\.php\?id=(\d+)',s): print('id',m.group(1))
PY
RSH
