set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
A=https://assistant.keplerops.test
login(){ curl -sS -m 10 --cacert $CA -X POST -H 'Content-Type: application/json' -d "{\"username\":\"$1\",\"password\":\"$2\"}" "$A/api/request-token" | python3 -c 'import json,sys;d=json.load(sys.stdin);print(d.get("token") or "NONE")'; }
JWT=$(login rowan.ito fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo)
MJWT=$(login maya.ranscombe sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk)
SUP=fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b
echo "JWT=${#JWT} MJWT=${#MJWT}"

probe(){ # path method extra-args...
  p=$1; m=${2:-GET}; shift 2
  out=$(curl -sS -m 8 --cacert $CA -X "$m" "$@" -o /tmp/pb -w '%{http_code}' "$A$p")
  body=$(head -c 160 /tmp/pb | tr '\n' ' ')
  case "$body" in
    *"<!DOCTYPE html>"*) body="SPA" ;;
  esac
  echo "$m $p -> $out :: $body"
}

echo "#### session-ish paths (no auth)"
for p in /api/session /api/session/login /api/session/new /api/session/create /api/session/start /api/session/request /api/sessions /api/auth/session /api/auth/login /api/support/session /api/support/sessions /api/support/login /api/support/token /api/integration/session /api/integration/token /api/fieldkest/session /api/fieldkest/token /api/account/session /api/staff/session /api/osticket/session /api/ticket/session /api/answers /api/answer /api/conversations /api/threads /api/cases /api/documents /api/selections /api/completions/examples/COMP-JOB-17; do
  probe "$p" GET
done

echo "#### POST /api/session-ish with jwt"
for p in /api/session "/api/session/login" /api/session/new /api/session/create /api/support/session /api/auth/session /api/integration/session /api/answers; do
  probe "$p" POST -H "Authorization: Bearer $JWT" -H 'Content-Type: application/json' -d '{"username":"rowan.ito","password":"fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo","context_id":"ctx-support-private-v4","conversation_id":"CONV-SUP-2841-19"}'
done

echo "#### auth variants on /api/conversations/CONV-SUP-2841-19"
C=/api/conversations/CONV-SUP-2841-19
probe "$C" GET -H "Authorization: Bearer $JWT"
probe "$C" GET -H "Authorization: Bearer $SUP"
probe "$C" GET -H "Authorization: Session $JWT"
probe "$C" GET -H "X-Session: $JWT"
probe "$C" GET -H "X-Session-Id: $JWT"
probe "$C" GET -H "X-AnythingLLM-Token: $JWT"
probe "$C" GET -H "X-Support-Token: $SUP"
probe "$C" GET -H "X-Integration-Token: $SUP"
probe "$C" GET -H "X-FieldKest-Token: $SUP"
probe "$C" GET -b "session=$JWT"
probe "$C" GET -b "token=$JWT"
probe "$C" GET -b "anythingllm=$JWT"
probe "$C" GET -b "anythingllm_session=$JWT"
probe "$C" GET -b "jwt=$JWT"
probe "$C" GET "$A$C?session=$JWT"
probe "$C" GET "$A$C?token=$JWT"
probe "$C" GET -u "rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
probe "$C" GET -u "rowan.ito:$JWT"

echo "#### osticket login then cookie on assistant"
rm -f /tmp/ost.jar
curl -sS -m 10 --cacert $CA -c /tmp/ost.jar -o /tmp/lp.html "$A/../../" 2>/dev/null
S2=https://support.keplerops.test
curl -sS -m 10 --cacert $CA -c /tmp/ost.jar -o /tmp/lp.html "$S2/scp/login.php"
CSRF=$(grep -oE 'name="__CSRFToken__"[^>]*value="[a-f0-9]+"' /tmp/lp.html | grep -oE '[a-f0-9]{16,}' | head -1)
curl -sS -m 10 --cacert $CA -b /tmp/ost.jar -c /tmp/ost.jar -o /dev/null -w 'login:%{http_code}\n' \
  --data-urlencode "userid=maya.ranscombe" --data-urlencode "passwd=sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk" --data-urlencode "do=sign-in" --data-urlencode "__CSRFToken__=$CSRF" "$S2/scp/login.php"
grep -o 'OSTSESSID.*' /tmp/ost.jar | head -3
probe "$C" GET -b /tmp/ost.jar
probe "$C" GET -b "OSTSESSID=$(grep OSTSESSID /tmp/ost.jar | awk '{print $7}' | tail -1)"

echo "#### ANSWER THREAD access"
for u in "$JWT" "$MJWT"; do
  echo "--- token ${u:0:12}"
  for p in "/api/workspace/support-private/thread/2ddf90fa-67b2-4637-a1d9-19404b7bc234/chats" "/api/workspace/support-private/thread/2ddf90fa-67b2-4637-a1d9-19404b7bc234" "/api/workspace/support-private/threads" "/api/workspace/rillhaven-support/threads"; do
    probe "$p" GET -H "Authorization: Bearer $u"
  done
done
echo "#### document content attempts (rowan jwt)"
for p in "/api/workspace/support-private/document/1b9adb92-643d-4888-9cc4-53a56b73754b" "/api/document/1b9adb92-643d-4888-9cc4-53a56b73754b" "/api/workspace/support-private/document/e93f0368-c6f2-4acb-8ae0-964a03b34698" "/api/workspace/support-private/documents/1b9adb92-643d-4888-9cc4-53a56b73754b"; do
  probe "$p" GET -H "Authorization: Bearer $JWT"
done
INNER
echo DONE_MARK_$RANDOM
