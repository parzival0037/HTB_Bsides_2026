set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
CA=/home/rowan/.local/share/keplerops/ca.crt
B=https://support.keplerops.test
J=/tmp/ckt3.txt; rm -f $J
TOKEN=k17-talia-mornac-review-token-2841
curl -sS -m 10 --cacert $CA -c $J -b $J "$B/scp/pwreset.php?token=$TOKEN" -o /tmp/x1.html
T=$(grep -oE 'name="__CSRFToken__" value="[^"]+"' /tmp/x1.html | sed -E 's/.*value="([^"]+)".*/\1/')
curl -sS -m 10 --cacert $CA -b $J -c $J -X POST "$B/scp/pwreset.php" \
  --data-urlencode "__CSRFToken__=$T" --data-urlencode "do=newpasswd" --data-urlencode "token=$TOKEN" \
  --data-urlencode "userid=talia.mornac" --data-urlencode "submit=Login" -o /dev/null
curl -sS -m 10 --cacert $CA -b $J -c $J "$B/scp/profile.php" -o /tmp/prof.html
echo "=== csrf occurrences ==="
grep -o -iE '.{0,60}csrf.{0,80}' /tmp/prof.html | head -20
echo "=== meta tags ==="
grep -oiE '<meta[^>]*>' /tmp/prof.html | head -20
echo "=== script vars token ==="
grep -oiE '(token|csrf)[^;]{0,120}' /tmp/prof.html | head -30
echo "=== dialog ==="
curl -sS -m 10 --cacert $CA -b $J -c $J "$B/scp/ajax.php/staff/4/change-password" -o /tmp/cp.html
grep -oE '<input[^>]*type="password"[^>]*>' /tmp/cp.html
grep -oE 'name="[^"]+"' /tmp/cp.html
echo "=== try POST with X-CSRFToken header using profile form token ==="
F1=$(python3 - <<'PY'
import re
d=open('/tmp/cp.html').read()
m=re.findall(r'name="([^"]+)"[^>]*value=""',d)
print(m[0] if m else '')
PY
)
F2=$(python3 - <<'PY'
import re
d=open('/tmp/cp.html').read()
m=re.findall(r'name="([^"]+)"[^>]*value=""',d)
print(m[-1] if m else '')
PY
)
echo "F1=$F1 F2=$F2"
curl -sS -m 10 --cacert $CA -b $J -c $J -i -X POST "$B/scp/ajax.php/staff/4/change-password" \
  -H "X-CSRFToken: $T" -H "X-Requested-With: XMLHttpRequest" \
  --data-urlencode "$F1=K17r3v13wTalia2841" --data-urlencode "$F2=K17r3v13wTalia2841" -o /tmp/chg2.txt
head -25 /tmp/chg2.txt
INNER
