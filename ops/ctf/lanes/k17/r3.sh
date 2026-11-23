set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
CA=/home/rowan/.local/share/keplerops/ca.crt
B=https://support.keplerops.test
J=/tmp/ck.txt; rm -f $J
echo "=== LOGIN PAGE ==="
curl -sS -m 10 --cacert $CA -c $J "$B/scp/login.php" -o /tmp/login.html
grep -oE '__CSRFToken__[^>]*' /tmp/login.html | head -3
TOK=$(grep -oE 'name="__CSRFToken__" value="[^"]+"' /tmp/login.html | sed -E 's/.*value="([^"]+)".*/\1/')
echo "TOK=$TOK"
echo "=== POST LOGIN ==="
curl -sS -m 10 --cacert $CA -b $J -c $J -i -X POST "$B/scp/login.php" \
  --data-urlencode "__CSRFToken__=$TOK" \
  --data-urlencode "userid=maya.ranscombe" \
  --data-urlencode "passwd=sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk" \
  --data-urlencode "dst=/scp/tickets.php" \
  --data-urlencode "submit=Sign In" -o /tmp/login_resp.txt
head -30 /tmp/login_resp.txt
echo "=== COOKIES ==="; cat $J
echo "=== TICKETS ==="
curl -sS -m 10 --cacert $CA -b $J -c $J "$B/scp/tickets.php" -o /tmp/tickets.html
wc -c /tmp/tickets.html
grep -oE 'tickets\.php\?id=[0-9]+' /tmp/tickets.html | sort -u
grep -oE '<a[^>]+href="[^"]*tickets[^"]*"[^>]*>[^<]*' /tmp/tickets.html | head -40
echo "=== TEXTDUMP ==="
python3 - <<'PY'
import re,html
d=open('/tmp/tickets.html',errors='ignore').read()
d=re.sub(r'<script.*?</script>','',d,flags=re.S)
d=re.sub(r'<style.*?</style>','',d,flags=re.S)
t=re.sub(r'<[^>]+>',' ',d)
t=html.unescape(t)
t=re.sub(r'\s+',' ',t)
print(t[:6000])
PY
INNER
