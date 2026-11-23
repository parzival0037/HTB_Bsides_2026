set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
CA=/home/rowan/.local/share/keplerops/ca.crt
B=https://support.keplerops.test
J=/tmp/ckt.txt; rm -f $J
TOKEN=k17-talia-mornac-review-token-2841
curl -sS -m 10 --cacert $CA -c $J -b $J "$B/scp/pwreset.php?token=$TOKEN" -o /tmp/x1.html
T=$(grep -oE 'name="__CSRFToken__" value="[^"]+"' /tmp/x1.html | sed -E 's/.*value="([^"]+)".*/\1/')
curl -sS -m 10 --cacert $CA -b $J -c $J -X POST "$B/scp/pwreset.php" \
  --data-urlencode "__CSRFToken__=$T" --data-urlencode "do=newpasswd" --data-urlencode "token=$TOKEN" \
  --data-urlencode "userid=talia.mornac" --data-urlencode "submit=Login" -o /dev/null
dump(){ echo "########## $1"; curl -sS -m 10 --cacert $CA -b $J -c $J "$B$1" -o /tmp/pg.html; python3 - <<'PY'
import re,html
d=open('/tmp/pg.html',errors='ignore').read()
d=re.sub(r'<script.*?</script>','',d,flags=re.S); d=re.sub(r'<style.*?</style>','',d,flags=re.S)
links=[(h,html.unescape(re.sub(r'<[^>]+>','',t)).strip()) for h,t in re.findall(r'<a[^>]+href="([^"]+)"[^>]*>(.*?)</a>',d,flags=re.S)]
print('LINKS:','; '.join(f'{h}={t}' for h,t in links if t)[:2500])
t=re.sub(r'<[^>]+>',' ',d); t=html.unescape(t); t=re.sub(r'\s+',' ',t)
print('TEXT:',t[:4000])
PY
}
dump "/scp/index.php"
dump "/scp/tickets.php"
dump "/scp/tickets.php?queue=6"
dump "/scp/profile.php"
for id in 1 2 3 4 5; do dump "/scp/tickets.php?id=$id"; done
INNER
