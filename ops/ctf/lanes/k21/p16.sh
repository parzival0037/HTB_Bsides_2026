set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
A=https://assistant.keplerops.test
C="$A/api/conversations/CONV-SUP-2841-19"
JWT=$(curl -sS -m 10 --cacert $CA -X POST -H 'Content-Type: application/json' -d '{"username":"rowan.ito","password":"fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"}' "$A/api/request-token" | python3 -c 'import json,sys;print(json.load(sys.stdin)["token"])')
MJWT=$(curl -sS -m 10 --cacert $CA -X POST -H 'Content-Type: application/json' -d '{"username":"maya.ranscombe","password":"sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk"}' "$A/api/request-token" | python3 -c 'import json,sys;print(json.load(sys.stdin)["token"])')
SUP=fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b
ANSWER_THREAD=2ddf90fa-67b2-4637-a1d9-19404b7bc234
show(){ code=$1; body=$2; if echo "$body" | grep -q session_required; then return; fi; echo "*** $3 -> $code :: $(echo "$body" | head -c 300)"; }
tryh(){ hdr="$1"; desc="$2"; r=$(curl -sSk -m 8 --cacert $CA -H "$hdr" -w '|%{http_code}' "$C"); code=${r##*|}; body=${r%|*}; show "$code" "$body" "$desc"; }
tryc(){ ck="$1"; desc="$2"; r=$(curl -sSk -m 8 --cacert $CA -b "$ck" -w '|%{http_code}' "$C"); code=${r##*|}; body=${r%|*}; show "$code" "$body" "$desc"; }
tryq(){ q="$1"; desc="$2"; r=$(curl -sSk -m 8 --cacert $CA -w '|%{http_code}' "$C?$q"); code=${r##*|}; body=${r%|*}; show "$code" "$body" "$desc"; }
echo "#### headers"
for val in "$SUP" "$JWT" "$MJWT" "$ANSWER_THREAD"; do
  for h in X-Support-Authorization X-FieldKest-Authorization X-FieldKest-Session X-Support-Session X-Session-Token X-Auth-Token X-Token X-Access-Token X-Client-Session; do
    tryh "$h: $val" "$h=${val:0:18}"
  done
  for scheme in Bearer Support FieldKest Token Session Basic; do
    tryh "Authorization: $scheme $val" "auth $scheme ${val:0:18}"
  done
done
echo "#### cookies"
for val in "$SUP" "$JWT" "$MJWT" "$ANSWER_THREAD" 1; do
  for c in fieldkest_support fieldkest_session fk_support fk_session session sid support_session assistant_session anythingllm_session anythingllm_token token auth fieldkest kf_session kb_session; do
    tryc "$c=$val" "cookie $c=${val:0:14}"
  done
done
echo "#### query"
for val in "$SUP" "$JWT" "$ANSWER_THREAD"; do
  for q in session token auth sid support_session; do
    tryq "$q=$val" "query $q=${val:0:14}"
  done
done
echo "#### basic variants"
for u in "support:$SUP" "fieldkest:$SUP" "rowan.ito:$SUP" ":${SUP}" "assistant:$SUP"; do
  r=$(curl -sSk -m 8 --cacert $CA -u "$u" -w '|%{http_code}' "$C"); code=${r##*|}; body=${r%|*}; show "$code" "$body" "basic ${u%%:*}"
done
echo "#### done"
INNER
echo DONE_MARK_$RANDOM
