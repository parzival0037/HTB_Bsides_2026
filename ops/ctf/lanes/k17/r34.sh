set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
S2=https://staff.keplerops.test
U='rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'
T='fk_cert_enrollment_Um9U1sNZQ5b_Cb08iirD4H-BKfz8aMF9'
echo "===== GET enrollment ====="
curl -sSk -m 8 --cacert $CA -i "$S2/api/enrollment/StaffArchiveUser" | head -30
echo; echo "===== GET enrollment (bearer worker) ====="
curl -sSk -m 8 --cacert $CA -i -H "Authorization: Bearer $T" "$S2/api/enrollment/StaffArchiveUser" | head -40
echo; echo "===== POST enrollment empty ====="
curl -sSk -m 8 --cacert $CA -i -X POST -H "Authorization: Bearer $T" -H 'Content-Type: application/json' -d '{}' "$S2/api/enrollment/StaffArchiveUser" | head -40
echo; echo "===== POST enrollment basic auth variants ====="
for body in '{}' '{"subject":"evan.calderoux@keplerops.test"}' '{"username":"evan.calderoux"}' '{"cn":"evan.calderoux@keplerops.test"}'; do
 echo "--- $body"
 curl -sSk -m 8 --cacert $CA -u "$U" -X POST -H 'Content-Type: application/json' -d "$body" -w '\n[%{http_code}]\n' "$S2/api/enrollment/StaffArchiveUser" | head -c 800; echo
done
echo "===== staff API root/docs ====="
for p in /api /api/ /api/enrollment /api/enrollment/StaffArchiveUser/docs /.well-known/fieldkest-client /api/service-directory /openapi.json; do
 echo "--- $p"
 curl -sSk -m 8 --cacert $CA -u "$U" -w '\n[%{http_code}]\n' "$S2$p" | head -c 900; echo
done
echo "===== REV-2841 raw (ticket id 6) ====="
J=/tmp/ckrev.txt; rm -f $J
curl -sSk -m 10 --cacert $CA -c $J "https://support.keplerops.test/scp/login.php" -o /tmp/l.html
CS=$(grep -oE 'name="__CSRFToken__" value="[^"]+"' /tmp/l.html | sed -E 's/.*value="([^"]+)".*/\1/')
curl -sSk -m 10 --cacert $CA -b $J -c $J -X POST "https://support.keplerops.test/scp/login.php" \
 --data-urlencode "__CSRFToken__=$CS" --data-urlencode "userid=maya.ranscombe" \
 --data-urlencode "passwd=sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk" \
 --data-urlencode "dst=/scp/tickets.php" --data-urlencode "submit=Sign In" -o /dev/null
curl -sSk -m 10 --cacert $CA -b $J -c $J "https://support.keplerops.test/scp/tickets.php?id=6" -o /tmp/rev.html
grep -oiE '.{0,200}cinder.{0,300}' /tmp/rev.html | head -10
echo "--- posters/notes ids"
grep -oiE '(class="[^"]*(author|poster|message)[^"]*"|<div class="[^"]*thread[^"]*")' /tmp/rev.html | head -20
echo "--- all internal note text blocks"
python3 - <<'PY'
import re,html
d=open('/tmp/rev.html',errors='ignore').read()
# find ticket thread entries
for m in re.finditer(r'<div class="[^"]*thread-body[^"]*">(.*?)</div>',d,flags=re.S):
    t=re.sub(r'<[^>]+>',' ',m.group(1)); t=html.unescape(t); t=re.sub(r'\s+',' ',t)
    print('BODY:',t[:600])
PY
echo "--- attachment links"
grep -oiE 'href="[^"]*(file|attach|download)[^"]*"' /tmp/rev.html | head -20
INNER
echo DONE_R34
