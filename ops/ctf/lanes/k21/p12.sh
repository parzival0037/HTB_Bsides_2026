set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
A=https://assistant.keplerops.test
B=https://staff.keplerops.test
SUPURL=https://support.keplerops.test:8443
DEV='rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'
SUPTOK=fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b
echo "######## staff note NOTE-SUP-2841-7"
curl -sSk -m 10 --cacert $CA -u "$DEV" -i "$B/api/notes/NOTE-SUP-2841-7" | head -40
echo "######## staff enrollment template"
curl -sSk -m 10 --cacert $CA -u "$DEV" -i "$B/api/enrollment/StaffArchiveUser" | head -60
echo "######## support handover current"
curl -sSk -m 10 --cacert $CA -H "Authorization: Bearer $SUPTOK" -i "$SUPURL/api/handovers/current" | head -60
echo "######## assistant answers basic dev variants"
for body in '{"request":"private_escalation"}' '{"request":"private_escalation","context_id":"ctx-support-private-v4","conversation_id":"CONV-SUP-2841-19"}' '{"request":"private_escalation","context_id":"ctx-support-private-v4"}' '{"request":"compatibility_review"}' '{"request":"private_escalation","session":"fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b"}'; do
  echo "--- $body"
  curl -sSk -m 15 --cacert $CA -u "$DEV" -H 'Content-Type: application/json' -d "$body" -w '\n[%{http_code}]\n' "$A/api/answers" | head -c 900
done
echo "######## managed-identities with service_registration ids"
for sid in OIDC-FIELDKEST-SUPPORT support fieldkest-support NOTE-SUP-2841-7; do
  echo "--- $sid"
  curl -sSk -m 10 --cacert $CA -u "$DEV" -X POST -H 'Content-Type: application/json' -d '{}' -w '\n[%{http_code}]\n' "$B/api/managed-identities/$sid/session" | head -c 500
done
echo "######## service-directory variants"
for q in "?service=assistant" "/assistant" "/support" "/all"; do
  echo "--- $q"; curl -sSk -m 10 --cacert $CA -u "$DEV" -w '\n[%{http_code}]\n' "$B/api/service-directory$q" | head -c 500
done
INNER
echo DONE_MARK_$RANDOM
