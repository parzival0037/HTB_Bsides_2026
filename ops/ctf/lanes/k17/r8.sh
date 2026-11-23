set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
CA=/home/rowan/.local/share/keplerops/ca.crt
B=https://support.keplerops.test
J=/tmp/ck5.txt; rm -f $J
TOKEN=k17-talia-mornac-review-token-2841
curl -sS -m 10 --cacert $CA -c $J -b $J "$B/scp/pwreset.php?token=$TOKEN" -o /tmp/s1.html
T1=$(grep -oE 'name="__CSRFToken__" value="[^"]+"' /tmp/s1.html | sed -E 's/.*value="([^"]+)".*/\1/')
echo "STEP1 TOK=$T1"
echo "=== STEP2 POST userid ==="
curl -sS -m 10 --cacert $CA -b $J -c $J -X POST "$B/scp/pwreset.php" \
 --data-urlencode "__CSRFToken__=$T1" --data-urlencode "do=newpasswd" --data-urlencode "token=$TOKEN" \
 --data-urlencode "userid=talia.mornac-review" --data-urlencode "submit=Login" -o /tmp/s2.html -i | head -15
echo "--- s2 forms ---"; grep -oE '<form[^>]*>|<input[^>]*>|<h3>[^<]*' /tmp/s2.html
echo "--- s2 text ---"
python3 - <<'PY'
import re,html
d=open('/tmp/s2.html',errors='ignore').read()
d=re.sub(r'<script.*?</script>','',d,flags=re.S); d=re.sub(r'<style.*?</style>','',d,flags=re.S)
t=re.sub(r'<[^>]+>',' ',d); t=html.unescape(t); t=re.sub(r'\s+',' ',t)
print(t[:1500])
PY
INNER
