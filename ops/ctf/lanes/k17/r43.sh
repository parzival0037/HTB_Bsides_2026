set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
B=https://support.keplerops.test
J=/tmp/cktal.txt; rm -f $J
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
print(t[:4000])
PY
}
echo "===== talia open tickets list (all) ====="
curl -sSk -m 10 --cacert $CA -b $J -c $J "$B/scp/tickets.php" -o /tmp/pg.html; TXT
echo; echo "===== talia search cinder ====="
curl -sSk -m 10 --cacert $CA -b $J -c $J "$B/scp/tickets.php?a=search&keywords=cinder" -o /tmp/pg.html; TXT | head -c 2500
echo; echo "===== talia agent directory ====="
curl -sSk -m 10 --cacert $CA -b $J -c $J "$B/scp/directory.php" -o /tmp/pg.html; TXT | head -c 2500
echo; echo "===== talia ticket ids 1..12 titles ====="
for id in $(seq 1 12); do
 curl -sSk -m 8 --cacert $CA -b $J -c $J -o /tmp/t.html -w "id=$id code=%{http_code} " "$B/scp/tickets.php?id=$id"
 grep -oE '<title>[^<]*' /tmp/t.html | head -1
done
echo "===== pwreset raw with token ====="
curl -sSk -m 10 --cacert $CA -b $J -c $J "$B/scp/pwreset.php?token=k17-talia-mornac-review-token-2841" -o /tmp/pw.html
grep -oE 'token|Reset|reset|newpass|do=[a-z]+|<form[^>]*>|<input[^>]*>|error|invalid|expired' /tmp/pw.html | sort | uniq -c | head -30
echo "--- pwreset with do=reset"
curl -sSk -m 10 --cacert $CA -b $J -c $J "$B/scp/pwreset.php?do=reset&token=k17-talia-mornac-review-token-2841" -o /tmp/pw2.html
grep -oE 'token|Reset|reset|newpass|do=[a-z]+|<form[^>]*>|<input[^>]*>|error|invalid|expired' /tmp/pw2.html | sort | uniq -c | head -30
INNER
echo DONE_R43
