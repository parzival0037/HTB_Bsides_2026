set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
CA=/home/rowan/.local/share/keplerops/ca.crt
B=https://support.keplerops.test
J=/tmp/ckt5.txt; rm -f $J
curl -sS -m 10 --cacert $CA -c $J "$B/scp/login.php" -o /tmp/l.html
T=$(grep -oE 'name="__CSRFToken__" value="[^"]+"' /tmp/l.html | sed -E 's/.*value="([^"]+)".*/\1/')
curl -sS -m 10 --cacert $CA -b $J -c $J -X POST "$B/scp/login.php" \
 --data-urlencode "__CSRFToken__=$T" --data-urlencode "userid=talia.mornac" \
 --data-urlencode "passwd=K17r3v13wTalia2841" --data-urlencode "dst=/scp/tickets.php" \
 --data-urlencode "submit=Sign In" -o /dev/null
curl -sS -m 10 --cacert $CA -b $J -c $J "$B/scp/tickets.php?id=6" -o /tmp/t6.html
echo "=== ATTACHMENT/LINKS ==="
grep -oE '(href|src)="[^"]*"' /tmp/t6.html | grep -viE 'css|js|images|logo|favicon' | sort -u | head -60
echo "=== TEXT ==="
python3 - <<'PY'
import re,html
d=open('/tmp/t6.html',errors='ignore').read()
d=re.sub(r'<script.*?</script>','',d,flags=re.S); d=re.sub(r'<style.*?</style>','',d,flags=re.S)
t=re.sub(r'<[^>]+>',' ',d); t=html.unescape(t); t=re.sub(r'\s+',' ',t)
print(t[:8000])
PY
INNER
