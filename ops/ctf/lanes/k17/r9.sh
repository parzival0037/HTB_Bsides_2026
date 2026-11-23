set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
CA=/home/rowan/.local/share/keplerops/ca.crt
B=https://support.keplerops.test
J=/tmp/ck6.txt; rm -f $J
curl -sS -m 10 --cacert $CA -c $J "$B/scp/login.php" -o /tmp/l.html
T=$(grep -oE 'name="__CSRFToken__" value="[^"]+"' /tmp/l.html | sed -E 's/.*value="([^"]+)".*/\1/')
curl -sS -m 10 --cacert $CA -b $J -c $J -X POST "$B/scp/login.php" \
 --data-urlencode "__CSRFToken__=$T" --data-urlencode "userid=maya.ranscombe" \
 --data-urlencode "passwd=sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk" \
 --data-urlencode "dst=/scp/tickets.php" --data-urlencode "submit=Sign In" -o /dev/null
for u in "agents.php" "agents.php?type=a" "directory.php" "agents.php?do=search&q=talia"; do
echo "##### $u"
curl -sS -m 10 --cacert $CA -b $J -c $J "$B/scp/$u" -o /tmp/a.html
python3 - <<'PY'
import re,html
d=open('/tmp/a.html',errors='ignore').read()
d=re.sub(r'<script.*?</script>','',d,flags=re.S); d=re.sub(r'<style.*?</style>','',d,flags=re.S)
links=re.findall(r'href="([^"]+)"[^>]*>([^<]{1,80})',d)
for h,t in links:
    if 'agent' in h or 'talia' in t.lower() or 'mornac' in t.lower():
        print(h,'|',html.unescape(t.strip()))
t=re.sub(r'<[^>]+>',' ',d); t=html.unescape(t); t=re.sub(r'\s+',' ',t)
print('TEXT:',t[:1200])
PY
done
INNER
