set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
CA=/home/rowan/.local/share/keplerops/ca.crt
B=https://support.keplerops.test
J=/tmp/ck2.txt; rm -f $J
echo "=== PW RESET PAGE ==="
curl -sS -m 10 --cacert $CA -c $J -b $J "$B/scp/pwreset.php?token=k17-talia-mornac-review-token-2841" -o /tmp/pw.html -i | head -20
echo "--- forms ---"
grep -oE '<form[^>]*>' /tmp/pw.html
grep -oE '<input[^>]*>' /tmp/pw.html
grep -oE '<select[^>]*>|<option[^>]*>[^<]*' /tmp/pw.html | head -20
echo "--- text ---"
python3 - <<'PY'
import re,html
d=open('/tmp/pw.html',errors='ignore').read()
d=re.sub(r'<script.*?</script>','',d,flags=re.S); d=re.sub(r'<style.*?</style>','',d,flags=re.S)
t=re.sub(r'<[^>]+>',' ',d); t=html.unescape(t); t=re.sub(r'\s+',' ',t)
print(t[:3000])
PY
INNER
