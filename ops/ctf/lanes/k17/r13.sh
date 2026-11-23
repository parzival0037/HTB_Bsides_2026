set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
CA=/home/rowan/.local/share/keplerops/ca.crt
B=https://support.keplerops.test
J=/tmp/ckp.txt; rm -f $J
TOKEN=k17-talia-mornac-review-token-2841
curl -sS -m 10 --cacert $CA -c $J -b $J "$B/scp/pwreset.php?token=$TOKEN" -o /tmp/x1.html
T=$(grep -oE 'name="__CSRFToken__" value="[^"]+"' /tmp/x1.html | sed -E 's/.*value="([^"]+)".*/\1/')
curl -sS -m 10 --cacert $CA -b $J -c $J -X POST "$B/scp/pwreset.php" \
  --data-urlencode "__CSRFToken__=$T" --data-urlencode "do=newpasswd" --data-urlencode "token=$TOKEN" \
  --data-urlencode "userid=talia.mornac" --data-urlencode "submit=Login" -o /dev/null
curl -sS -m 10 --cacert $CA -b $J -c $J "$B/scp/profile.php" -o /tmp/prof.html
echo "=== FORM + INPUTS ==="
python3 - <<'PY'
import re
d=open('/tmp/prof.html',errors='ignore').read()
# print all forms and inputs with context
for m in re.finditer(r'<form\b.*?</form>', d, flags=re.S|re.I):
    f=m.group(0)
    print('FORM:', re.search(r'<form[^>]*>',f,flags=re.I).group(0))
    for inp in re.findall(r'<(input|select|textarea)\b.*?>', f, flags=re.S|re.I):
        print('  ', inp[:200].replace('\n',' '))
    print('---')
PY
# also extract password section context
grep -n -i -A6 -B6 'change password\|new password\|current password\|password' /tmp/prof.html | head -80
INNER
