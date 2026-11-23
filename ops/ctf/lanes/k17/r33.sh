set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
A=https://assistant.keplerops.test
B=https://support.keplerops.test
TOK=$(curl -sSk -m 10 --cacert $CA -X POST -H 'Content-Type: application/json' -d '{"username":"rowan.ito","password":"fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"}' "$A/api/request-token" | python3 -c 'import json,sys;print(json.load(sys.stdin).get("token",""))')
H="Authorization: Bearer $TOK"
echo "===== osTicket login maya ====="
rm -f /tmp/ost.ck
curl -sSk -m 10 --cacert $CA -c /tmp/ost.ck "$B/scp/login.php" -o /tmp/ostlogin.html
CS=$(grep -oE 'name="__CSRFToken__" value="[^"]+"' /tmp/ostlogin.html | sed -E 's/.*value="([^"]+)".*/\1/')
curl -sSk -m 10 --cacert $CA -b /tmp/ost.ck -c /tmp/ost.ck -X POST "$B/scp/login.php" \
 --data-urlencode "__CSRFToken__=$CS" --data-urlencode "userid=maya.ranscombe" \
 --data-urlencode "passwd=sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk" \
 --data-urlencode "dst=/scp/tickets.php" --data-urlencode "submit=Sign In" -o /dev/null -w 'login=%{http_code}\n'
OSTC=$(python3 - <<'PY'
import re
try:
    d=open('/tmp/ost.ck').read()
    m=re.findall(r'OSTSESSID\s+(\w+)',d)
    print(m[-1] if m else '')
except: print('')
PY
)
echo "OSTSESSID=$OSTC"
echo "===== staff login rowan ====="
rm -f /tmp/kb.ck
curl -sSk -m 10 --cacert $CA -c /tmp/kb.ck "https://staff.keplerops.test/login" -o /tmp/kbl.html
KC=$(grep -oE 'name="csrf_token" value="[^"]+"' /tmp/kbl.html | sed -E 's/.*value="([^"]+)".*/\1/')
curl -sSk -m 10 --cacert $CA -b /tmp/kb.ck -c /tmp/kb.ck -X POST "https://staff.keplerops.test/login/check" \
 --data-urlencode "csrf_token=$KC" --data-urlencode "username=rowan.ito" \
 --data-urlencode "password=fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo" --data-urlencode "remember_me=1" -o /dev/null -w 'login=%{http_code}\n'
KBC=$(python3 - <<'PY'
import re
try:
    d=open('/tmp/kb.ck').read()
    m=re.findall(r'KB_SID\s+(\w+)',d)
    print(m[-1] if m else '')
except: print('')
PY
)
echo "KB_SID=$KBC"
echo "===== assistant custom route with cookies ====="
for cook in "OSTSESSID=$OSTC" "KB_SID=$KBC" "OSTSESSID=$OSTC; KB_SID=$KBC" "session=$TOK" "token=$TOK" "anythingllm_session=$TOK"; do
  echo "--- cookie: $cook"
  curl -sSk -m 10 --cacert $CA -H "$H" -H "Cookie: $cook" -w '\n[%{http_code}]\n' "$A/api/conversations/CONV-SUP-2841-19" | head -c 800; echo
done
echo "===== assistant stock workspace detail ====="
curl -sSk -m 10 --cacert $CA -H "$H" -w '\n[%{http_code}]\n' "$A/api/workspace/support-private" | head -c 2500; echo
echo "===== support diagnostics job ====="
SA='Authorization: Bearer fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b'
curl -sSk -m 10 -H "$SA" -w '\n[%{http_code}]\n' "https://support.keplerops.test:8443/api/diagnostics/JOB-215D690E28A8" | head -c 3000; echo
INNER
echo DONE_R33
