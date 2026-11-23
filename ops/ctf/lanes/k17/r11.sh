set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
CA=/home/rowan/.local/share/keplerops/ca.crt
B=https://support.keplerops.test
J=/tmp/ckr.txt; rm -f $J
TOKEN=k17-talia-mornac-review-token-2841
curl -sS -m 10 --cacert $CA -c $J -b $J "$B/scp/pwreset.php?token=$TOKEN" -o /tmp/x1.html
T=$(grep -oE 'name="__CSRFToken__" value="[^"]+"' /tmp/x1.html | sed -E 's/.*value="([^"]+)".*/\1/')
echo "=== POST talia.mornac, headers ==="
curl -sS -m 10 --cacert $CA -b $J -c $J -i -X POST "$B/scp/pwreset.php" \
  --data-urlencode "__CSRFToken__=$T" --data-urlencode "do=newpasswd" --data-urlencode "token=$TOKEN" \
  --data-urlencode "userid=talia.mornac" --data-urlencode "submit=Login" -o /tmp/hdr.txt
head -25 /tmp/hdr.txt
LOC=$(grep -i '^location:' /tmp/hdr.txt | tr -d '\r' | awk '{print $2}')
echo "LOC=$LOC"
echo "=== FOLLOW ==="
curl -sS -m 10 --cacert $CA -b $J -c $J -i "$B/scp/$LOC" -o /tmp/x3.html 2>/dev/null || curl -sS -m 10 --cacert $CA -b $J -c $J -i "$LOC" -o /tmp/x3.html
head -15 /tmp/x3.html
echo "--- forms ---"; grep -oE '<form[^>]*>|<input[^>]*>|<h3>[^<]*' /tmp/x3.html
echo "--- text ---"
python3 - <<'PY'
import re,html
d=open('/tmp/x3.html',errors='ignore').read()
d=re.sub(r'<script.*?</script>','',d,flags=re.S); d=re.sub(r'<style.*?</style>','',d,flags=re.S)
t=re.sub(r'<[^>]+>',' ',d); t=html.unescape(t); t=re.sub(r'\s+',' ',t)
print(t[:2000])
PY
INNER
