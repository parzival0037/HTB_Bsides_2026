set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
export KRB5CCNAME=FILE:/home/rowan/work/krb5cc_evan
echo "===== SPNEGO staff/ with headers ====="
curl -sSk -m 10 --cacert $CA --negotiate -u : -i "https://staff.keplerops.test/" | head -25
echo; echo "===== SPNEGO staff/dashboard follow ====="
curl -sSk -m 10 --cacert $CA --negotiate -u : -L -i "https://staff.keplerops.test/dashboard" -o /tmp/sd.html
head -30 /tmp/sd.html
echo "--- body text"
python3 - <<'PY'
import re,html
d=open('/tmp/sd.html',errors='ignore').read()
d=re.sub(r'<script.*?</script>','',d,flags=re.S)
t=re.sub(r'<[^>]+>',' ',d); t=html.unescape(t); t=re.sub(r'\s+',' ',t)
print(t[:1500])
PY
echo "===== SPNEGO on other hosts ====="
for h in staff.keplerops.test workboard.keplerops.test support.keplerops.test tickets.keplerops.test workload.keplerops.test cloud-api.keplerops.test data.keplerops.test objects.keplerops.test assistant.keplerops.test review.keplerops.test id.keplerops.test identity.keplerops.test; do
 code=$(curl -sSk -m 8 --cacert $CA --negotiate -u : -o /tmp/ng.out -w '%{http_code}' "https://$h/" 2>/dev/null)
 loc=$(curl -sSk -m 8 --cacert $CA --negotiate -u : -D - -o /dev/null "https://$h/" 2>/dev/null | grep -i '^location:' | tr -d '\r')
 echo "$h [$code] $loc :: $(head -c 120 /tmp/ng.out | tr -d '\n')"
done
echo "===== SPNEGO login endpoints ====="
for p in /login /login/check /spnego /login/spnego /auth/spnego /api/login /scp/ /scp/login.php /scp/index.php; do
 echo "--- staff$p"
 curl -sSk -m 8 --cacert $CA --negotiate -u : -i "https://staff.keplerops.test$p" 2>/dev/null | head -12
done
INNER
echo DONE_R60
