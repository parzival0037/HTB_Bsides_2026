set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
CA=/home/rowan/.local/share/keplerops/ca.crt
B=https://support.keplerops.test
J=/tmp/ck3.txt; rm -f $J
curl -sS -m 10 --cacert $CA -c $J -b $J "$B/scp/pwreset.php?token=k17-talia-mornac-review-token-2841" -o /tmp/pw.html
TOK=$(grep -oE 'name="__CSRFToken__" value="[^"]+"' /tmp/pw.html | sed -E 's/.*value="([^"]+)".*/\1/')
echo "TOK=$TOK"
echo "=== POST do=newpasswd ==="
curl -sS -m 10 --cacert $CA -b $J -c $J -i -X POST "$B/scp/pwreset.php" \
 --data-urlencode "__CSRFToken__=$TOK" --data-urlencode "do=newpasswd" \
 --data-urlencode "token=k17-talia-mornac-review-token-2841" --data-urlencode "submit=Login" -o /tmp/pw2.html
head -20 /tmp/pw2.html
echo "--- forms ---"; grep -oE '<form[^>]*>|<input[^>]*>' /tmp/pw2.html
echo "--- text ---"
python3 - <<'PY'
import re,html
d=open('/tmp/pw2.html',errors='ignore').read()
d=re.sub(r'<script.*?</script>','',d,flags=re.S); d=re.sub(r'<style.*?</style>','',d,flags=re.S)
t=re.sub(r'<[^>]+>',' ',d); t=html.unescape(t); t=re.sub(r'\s+',' ',t)
print(t[:3000])
PY
echo "=== COOKIES ==="; cat $J
INNER
