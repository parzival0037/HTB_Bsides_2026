set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
CA=/home/rowan/.local/share/keplerops/ca.crt
B=https://support.keplerops.test
J=/tmp/ckt2.txt; rm -f $J
TOKEN=k17-talia-mornac-review-token-2841
NEWPASS='K17r3v13w!Talia#2841'
curl -sS -m 10 --cacert $CA -c $J -b $J "$B/scp/pwreset.php?token=$TOKEN" -o /tmp/x1.html
T=$(grep -oE 'name="__CSRFToken__" value="[^"]+"' /tmp/x1.html | sed -E 's/.*value="([^"]+)".*/\1/')
curl -sS -m 10 --cacert $CA -b $J -c $J -X POST "$B/scp/pwreset.php" \
  --data-urlencode "__CSRFToken__=$T" --data-urlencode "do=newpasswd" --data-urlencode "token=$TOKEN" \
  --data-urlencode "userid=talia.mornac" --data-urlencode "submit=Login" -o /dev/null
echo "=== GET DIALOG ==="
curl -sS -m 10 --cacert $CA -b $J -c $J "$B/scp/ajax.php/staff/4/change-password" -o /tmp/cp.html
F1=$(grep -oE 'name="[a-f0-9]{16}"' /tmp/cp.html | head -1 | sed -E 's/name="([^"]+)"/\1/')
F2=$(grep -oE 'name="[a-f0-9]{16}"' /tmp/cp.html | tail -1 | sed -E 's/name="([^"]+)"/\1/')
echo "F1=$F1 F2=$F2"
echo "=== POST CHANGE ==="
curl -sS -m 10 --cacert $CA -b $J -c $J -i -X POST "$B/scp/ajax.php/staff/4/change-password" \
  --data-urlencode "$F1=$NEWPASS" --data-urlencode "$F2=$NEWPASS" -o /tmp/chg.txt
head -20 /tmp/chg.txt
echo "=== AFTER: profile ==="
curl -sS -m 10 --cacert $CA -b $J -c $J "$B/scp/profile.php" -o /tmp/prof2.html
grep -oE 'msg_error|You must|change your password' /tmp/prof2.html | head
python3 - <<'PY'
import re,html
d=open('/tmp/prof2.html',errors='ignore').read()
d=re.sub(r'<script.*?</script>','',d,flags=re.S); d=re.sub(r'<style.*?</style>','',d,flags=re.S)
t=re.sub(r'<[^>]+>',' ',d); t=html.unescape(t); t=re.sub(r'\s+',' ',t)
print(t[:800])
PY
echo "=== TICKETS ==="
curl -sS -m 10 --cacert $CA -b $J -c $J "$B/scp/tickets.php" -o /tmp/tk.html
grep -oE 'tickets\.php\?id=[0-9]+' /tmp/tk.html | sort -u
python3 - <<'PY'
import re,html
d=open('/tmp/tk.html',errors='ignore').read()
d=re.sub(r'<script.*?</script>','',d,flags=re.S); d=re.sub(r'<style.*?</style>','',d,flags=re.S)
t=re.sub(r'<[^>]+>',' ',d); t=html.unescape(t); t=re.sub(r'\s+',' ',t)
print(t[:2500])
PY
INNER
