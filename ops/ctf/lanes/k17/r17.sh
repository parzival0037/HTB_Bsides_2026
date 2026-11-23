set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
CA=/home/rowan/.local/share/keplerops/ca.crt
B=https://support.keplerops.test
J=/tmp/ckt4.txt; rm -f $J
curl -sS -m 10 --cacert $CA -c $J "$B/scp/login.php" -o /tmp/l.html
T=$(grep -oE 'name="__CSRFToken__" value="[^"]+"' /tmp/l.html | sed -E 's/.*value="([^"]+)".*/\1/')
echo "=== LOGIN TALIA ==="
curl -sS -m 10 --cacert $CA -b $J -c $J -i -X POST "$B/scp/login.php" \
 --data-urlencode "__CSRFToken__=$T" --data-urlencode "userid=talia.mornac" \
 --data-urlencode "passwd=K17r3v13wTalia2841" --data-urlencode "dst=/scp/tickets.php" \
 --data-urlencode "submit=Sign In" -o /tmp/li.txt | head -15
head -20 /tmp/li.txt
dump(){ echo "########## $1"; curl -sS -m 10 --cacert $CA -b $J -c $J "$B$1" -o /tmp/pg.html; python3 - <<'PY'
import re,html
d=open('/tmp/pg.html',errors='ignore').read()
d=re.sub(r'<script.*?</script>','',d,flags=re.S); d=re.sub(r'<style.*?</style>','',d,flags=re.S)
links=[(h,html.unescape(re.sub(r'<[^>]+>','',t)).strip()) for h,t in re.findall(r'<a[^>]+href="([^"]+)"[^>]*>(.*?)</a>',d,flags=re.S)]
print('LINKS:','; '.join(f'{h}={t}' for h,t in links if t)[:1500])
t=re.sub(r'<[^>]+>',' ',d); t=html.unescape(t); t=re.sub(r'\s+',' ',t)
print('TEXT:',t[:4500])
PY
}
dump "/scp/tickets.php"
dump "/scp/index.php"
dump "/scp/tickets.php?queue=6"
dump "/scp/tasks.php"
dump "/scp/directory.php"
INNER
