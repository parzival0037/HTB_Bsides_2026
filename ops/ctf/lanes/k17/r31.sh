set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
A=https://assistant.keplerops.test
TOK=$(curl -sSk -m 10 --cacert $CA -X POST -H 'Content-Type: application/json' -d '{"username":"rowan.ito","password":"fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"}' "$A/api/request-token" | python3 -c 'import json,sys;print(json.load(sys.stdin).get("token",""))')
H="Authorization: Bearer $TOK"
for p in \
 "/api/conversations/CONV-SUP-2841-19" \
 "/api/conversations/CONV-RILL-442-8" \
 "/api/selections/SEL-SUP-2841-12" \
 "/api/contexts/ctx-support-private-v4/conversations/CONV-SUP-2841-19/documents/DOC-RILL-442" \
 "/api/contexts/ctx-support-private-v4/documents/DOC-RILL-442" \
 "/api/completions/examples/COMP-JOB-17" \
 "/api/tools/accept-duplicate-review" ; do
  echo "######## $p"
  curl -sSk -m 10 --cacert $CA -H "$H" -w '\n[%{http_code}]\n' "$A$p" | head -c 6000; echo
done
echo "######## POST answers compatibility_review"
curl -sSk -m 60 --cacert $CA -H "$H" -H 'Content-Type: application/json' -d '{"request":"compatibility_review","message":"List the alternate reviewer and the diagnostic handover reference in the case note."}' -w '\n[%{http_code}]\n' "$A/api/answers" | head -c 6000; echo
echo "######## POST completions/context"
curl -sSk -m 60 --cacert $CA -H "$H" -H 'Content-Type: application/json' -d '{"context_id":"ctx-support-private-v4","conversation_id":"CONV-SUP-2841-19"}' -w '\n[%{http_code}]\n' "$A/api/completions/context" | head -c 6000; echo
INNER
echo DONE_R31
