set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
T=https://tickets.keplerops.test
echo "===== tickets root ====="
curl -sSk -m 8 --cacert $CA -i "$T/" | head -20
echo; echo "===== tickets /scp/tickets.php ====="
curl -sSk -m 8 --cacert $CA -i "$T/scp/tickets.php" | head -20
echo; echo "===== login as maya on tickets vhost ====="
J=/tmp/ckt.txt; rm -f $J
curl -sSk -m 10 --cacert $CA -c $J "$T/scp/login.php" -o /tmp/l.html
CS=$(grep -oE 'name="__CSRFToken__" value="[^"]+"' /tmp/l.html | sed -E 's/.*value="([^"]+)".*/\1/')
echo "csrf=$CS"
curl -sSk -m 10 --cacert $CA -b $J -c $J -X POST "$T/scp/login.php" \
 --data-urlencode "__CSRFToken__=$CS" --data-urlencode "userid=maya.ranscombe" \
 --data-urlencode "passwd=sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk" \
 --data-urlencode "dst=/scp/tickets.php" --data-urlencode "submit=Sign In" -o /tmp/lr.html -w 'login=%{http_code}\n'
grep -oE '<title>[^<]*' /tmp/lr.html | head -1
TXT(){ python3 - <<'PY'
import re,html
d=open('/tmp/pg.html',errors='ignore').read()
d=re.sub(r'<script.*?</script>','',d,flags=re.S); d=re.sub(r'<style.*?</style>','',d,flags=re.S)
t=re.sub(r'<[^>]+>',' ',d); t=html.unescape(t); t=re.sub(r'\s+',' ',t)
print(t[:3000])
PY
}
curl -sSk -m 10 --cacert $CA -b $J -c $J "$T/scp/tickets.php" -o /tmp/pg.html; TXT
echo; echo "===== root page text ====="
curl -sSk -m 8 --cacert $CA "$T/" -o /tmp/pg.html; TXT | head -c 2000
INNER
echo DONE_R65
