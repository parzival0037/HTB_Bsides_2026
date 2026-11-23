set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
A=https://assistant.keplerops.test
SUP=fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b
echo "######## identity-access.md"
cat /home/rowan/work/identity-access.md
echo "######## README.md"
cat /home/rowan/README.md
echo "######## /etc/hosts"
cat /etc/hosts
echo "######## grep interesting strings in /home/rowan"
grep -rin --exclude-dir=node_modules --exclude-dir=.git --exclude-dir=.cache --exclude-dir=.config/chromium 'session_required\|answer_requests\|ctx-support\|CONV-SUP\|assistant' /home/rowan 2>/dev/null | head -40
echo "######## index.js search"
[ -s /tmp/idx.js ] || curl -sS -m 25 --cacert $CA "$A/index.js" -o /tmp/idx.js
grep -c 'session_required' /tmp/idx.js; grep -oE '.{80}session_required.{80}' /tmp/idx.js | head -5
grep -oE '.{60}(answer_requests|completions/examples|ctx-support).{100}' /tmp/idx.js | head -5
echo "######## POST /api/answers variants"
for spec in "jwt" "sup" "apikey" "none"; do
  case $spec in
    jwt) H='Content-Type: application/json'; T="Authorization: Bearer $(curl -sS -m 8 --cacert $CA -X POST -H 'Content-Type: application/json' -d '{"username":"rowan.ito","password":"fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"}' "$A/api/request-token" | python3 -c 'import json,sys;print(json.load(sys.stdin)["token"])')" ;;
    sup) H="Authorization: Bearer $SUP" ;;
    apikey) H="X-API-Key: $SUP" ;;
    none) H="X-Nothing: 1" ;;
  esac
  echo "--- $spec"
  if [ "$spec" = "jwt" ] || [ "$spec" = "sup" ]; then
    curl -sS -m 8 --cacert $CA -H "$H" -H 'Content-Type: application/json' -d '{"request":"private_escalation","context_id":"ctx-support-private-v4","conversation_id":"CONV-SUP-2841-19"}' -w '\n[%{http_code}]\n' "$A/api/answers" | head -c 500
  else
    curl -sS -m 8 --cacert $CA -H "$H" -H 'Content-Type: application/json' -d '{"request":"private_escalation"}' -w '\n[%{http_code}]\n' "$A/api/answers" | head -c 500
  fi
done
echo "######## OPTIONS/HEAD on overlay"
for p in /api/config /api/contexts /api/answers /api/conversations/CONV-SUP-2841-19 /api/completions/examples/COMP-JOB-17; do
  echo "--- OPTIONS $p"; curl -sS -m 8 --cacert $CA -X OPTIONS -i "$A$p" 2>&1 | head -12
done
echo "######## staff workboard"
for h in staff.keplerops.test workboard.keplerops.test; do
  echo "===== $h /"; curl -sSk -m 10 --cacert $CA -i "https://$h/" 2>&1 | head -20
done
INNER
echo DONE_MARK_$RANDOM
