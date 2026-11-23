set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
B=https://support.keplerops.test
J=/tmp/cktal2.txt; rm -f $J
curl -sSk -m 10 --cacert $CA -c $J "$B/scp/login.php" -o /tmp/l.html
CS=$(grep -oE 'name="__CSRFToken__" value="[^"]+"' /tmp/l.html | sed -E 's/.*value="([^"]+)".*/\1/')
curl -sSk -m 10 --cacert $CA -b $J -c $J -X POST "$B/scp/login.php" \
 --data-urlencode "__CSRFToken__=$CS" --data-urlencode "userid=talia.mornac" \
 --data-urlencode "passwd=K17r3v13wTalia2841" \
 --data-urlencode "dst=/scp/tickets.php" --data-urlencode "submit=Sign In" -o /dev/null
TXT(){ python3 - <<'PY'
import re,html
d=open('/tmp/pg.html',errors='ignore').read()
d=re.sub(r'<script.*?</script>','',d,flags=re.S); d=re.sub(r'<style.*?</style>','',d,flags=re.S)
t=re.sub(r'<[^>]+>',' ',d); t=html.unescape(t); t=re.sub(r'\s+',' ',t)
print(t[:2500])
PY
}
for q in "tickets.php?status=open" "tickets.php?status=closed" "tickets.php?status=resolved" "tickets.php?status=all" "tickets.php?status=assigned" "tickets.php?a=search&keywords=cinder&status=all" "tickets.php?a=search&keywords=alternate" "tickets.php?a=search&keywords=case+note" "tasks.php" "users.php" "admin.php?t=users&keywords=cinder"; do
 echo "===== $q"
 curl -sSk -m 10 --cacert $CA -b $J -c $J "$B/scp/$q" -o /tmp/pg.html; TXT | head -c 1600; echo
done
INNER
echo DONE_R51
