set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
A=https://assistant.keplerops.test
SUP=fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b
C="Cookie: fieldkest_support=$SUP"
echo "######## CONVERSATION full"
curl -sSk -m 10 --cacert $CA -H "$C" "$A/api/conversations/CONV-SUP-2841-19" | python3 -m json.tool 2>/dev/null || curl -sSk -m 10 --cacert $CA -H "$C" "$A/api/conversations/CONV-SUP-2841-19"
echo "######## CONVERSATION rill"
curl -sSk -m 10 --cacert $CA -H "$C" "$A/api/conversations/CONV-RILL-442-8" | python3 -m json.tool 2>/dev/null
echo "######## DOC nested"
curl -sSk -m 10 --cacert $CA -H "$C" "$A/api/contexts/ctx-support-private-v4/conversations/CONV-SUP-2841-19/documents/DOC-RILL-442" | python3 -m json.tool 2>/dev/null
echo "######## DOC nested rill context"
curl -sSk -m 10 --cacert $CA -H "$C" "$A/api/contexts/ctx-rill-support-v3/conversations/CONV-RILL-442-8/documents/DOC-RILL-442" | python3 -m json.tool 2>/dev/null
echo "######## SELECTION"
curl -sSk -m 10 --cacert $CA -H "$C" "$A/api/selections/SEL-SUP-2841-12" | python3 -m json.tool 2>/dev/null
echo "######## COMPLETION EXAMPLE"
curl -sSk -m 10 --cacert $CA -H "$C" "$A/api/completions/examples/COMP-JOB-17" | python3 -m json.tool 2>/dev/null
echo "######## ANSWERS private_escalation"
for body in '{"request":"private_escalation"}' '{"request":"private_escalation","context_id":"ctx-support-private-v4","conversation_id":"CONV-SUP-2841-19"}' '{"request":"private_escalation","tenant_id":"TEN-RILL-022"}'; do
  echo "--- $body"
  curl -sSk -m 60 --cacert $CA -H "$C" -H 'Content-Type: application/json' -d "$body" -w '\n[%{http_code}]\n' "$A/api/answers" | python3 -m json.tool 2>/dev/null || true
  curl -sSk -m 60 --cacert $CA -H "$C" -H 'Content-Type: application/json' -d "$body" -w '\n[%{http_code}]\n' "$A/api/answers" | head -c 1500
done
echo "######## ANSWERS compatibility_review"
curl -sSk -m 60 --cacert $CA -H "$C" -H 'Content-Type: application/json' -d '{"request":"compatibility_review"}' -w '\n[%{http_code}]\n' "$A/api/answers" | head -c 1500
echo "######## completion-context"
curl -sSk -m 60 --cacert $CA -H "$C" -H 'Content-Type: application/json' -d '{"context_id":"ctx-support-private-v4","conversation_id":"CONV-SUP-2841-19"}' -w '\n[%{http_code}]\n' "$A/api/completions/context" | head -c 2000
echo "######## accept-duplicate-review"
curl -sSk -m 30 --cacert $CA -H "$C" -H 'Content-Type: application/json' -d '{"review_id":"DREV-2841-2"}' -w '\n[%{http_code}]\n' "$A/api/tools/accept-duplicate-review" | head -c 1500
INNER
echo DONE_MARK_$RANDOM
