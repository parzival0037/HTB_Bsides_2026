set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
B=https://support.keplerops.test
J=/tmp/ckrev2.txt; rm -f $J
curl -sSk -m 10 --cacert $CA -c $J "$B/scp/login.php" -o /tmp/l.html
CS=$(grep -oE 'name="__CSRFToken__" value="[^"]+"' /tmp/l.html | sed -E 's/.*value="([^"]+)".*/\1/')
curl -sSk -m 10 --cacert $CA -b $J -c $J -X POST "$B/scp/login.php" \
 --data-urlencode "__CSRFToken__=$CS" --data-urlencode "userid=maya.ranscombe" \
 --data-urlencode "passwd=sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk" \
 --data-urlencode "dst=/scp/tickets.php" --data-urlencode "submit=Sign In" -o /dev/null
TXT(){ python3 - <<'PY'
import re,html
d=open('/tmp/pg.html',errors='ignore').read()
d=re.sub(r'<script.*?</script>','',d,flags=re.S); d=re.sub(r'<style.*?</style>','',d,flags=re.S)
t=re.sub(r'<[^>]+>',' ',d); t=html.unescape(t); t=re.sub(r'\s+',' ',t)
print(t[:3000])
PY
}
echo "===== agents page ====="
curl -sSk -m 10 --cacert $CA -b $J -c $J "$B/scp/agents.php" -o /tmp/pg.html; TXT
echo; echo "===== admin users ====="
curl -sSk -m 10 --cacert $CA -b $J -c $J "$B/scp/admin.php?t=users" -o /tmp/pg.html; TXT
echo; echo "===== search users cinder ====="
curl -sSk -m 10 --cacert $CA -b $J -c $J "$B/scp/admin.php?t=users&keywords=cinder" -o /tmp/pg.html; TXT
echo; echo "===== pwreset page with token ====="
rm -f /tmp/ckpr.txt
curl -sSk -m 10 --cacert $CA -b $J -c $J -c /tmp/ckpr.txt "$B/scp/pwreset.php?token=k17-talia-mornac-review-token-2841" -o /tmp/pg.html
TXT
echo; echo "--- form fields"
grep -oE '<form[^>]*>|<input[^>]*>|name="[^"]+"' /tmp/pg.html | head -30
echo "===== ticket REV-2841 thread internal ====="
for q in "tickets.php?id=6" "tickets.php?id=6&a=thread&type=internal" "tickets.php?id=6&a=thread&type=internal&n=1"; do
 echo "--- $q"
 curl -sSk -m 10 --cacert $CA -b $J -c $J "$B/scp/$q" -o /tmp/pg.html; TXT | head -c 2000; echo
done
INNER
echo DONE_R42
