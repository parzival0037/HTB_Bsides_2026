set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
export AWS_PAGER=""
echo "########## S3 backups"
aws --endpoint-url https://objects.keplerops.test s3 ls s3://fieldlink-exports/backups/ 2>&1 | head -40
echo "########## S3 recursive depth"
aws --endpoint-url https://objects.keplerops.test s3 ls --recursive s3://fieldlink-exports/ 2>&1 | head -60
echo "########## other bucket guesses"
for b in assistant assistant-exports anythingllm fieldlink-assistant support backup; do echo "--- $b"; aws --endpoint-url https://objects.keplerops.test s3 ls s3://$b 2>&1 | head -8; done
echo "########## OSTICKET LOGIN"
S2=https://support.keplerops.test
rm -f /tmp/ost.jar
curl -sS -m 10 --cacert $CA -c /tmp/ost.jar -o /tmp/login.html -w 'loginpage:%{http_code}\n' "$S2/scp/login.php"
grep -oE '<input[^>]+>' /tmp/login.html | head -20
CSRF=$(grep -oE 'name="__CSRFToken__"[^>]*value="[a-f0-9]+"' /tmp/login.html | grep -oE '[a-f0-9]{16,}' | head -1)
echo "CSRF=$CSRF"
curl -sS -m 10 --cacert $CA -b /tmp/ost.jar -c /tmp/ost.jar -o /tmp/login2.html -w 'loginpost:%{http_code} -> %{redirect_url}\n' \
  --data-urlencode "userid=maya.ranscombe" --data-urlencode "passwd=sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk" --data-urlencode "do=sign-in" --data-urlencode "__CSRFToken__=$CSRF" "$S2/scp/login.php"
curl -sS -m 10 --cacert $CA -b /tmp/ost.jar -o /tmp/tix.html -w 'tickets:%{http_code}\n' "$S2/scp/tickets.php"
grep -oE 'tickets\.php\?id=[0-9]+[^"]*' /tmp/tix.html | sort -u | head -20
grep -oE 'SUP-[0-9]+|ESC-[0-9]+|REV-[0-9]+' /tmp/tix.html | sort -u | head -20
echo "--- ticket rows"
python3 - <<'PY'
import re
h=open('/tmp/tix.html',errors='replace').read()
rows=re.findall(r'<tr[^>]*>(.*?)</tr>',h,re.S)
for r in rows[:20]:
    t=re.sub(r'<[^>]+>',' ',r)
    t=re.sub(r'\s+',' ',t).strip()
    if t: print(t[:200])
PY
INNER
echo DONE_MARK_$RANDOM
