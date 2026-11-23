set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
A=https://assistant.keplerops.test
B=https://staff.keplerops.test
DEV='rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'
SUP='rowan.ito:fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b'
MAY='maya.ranscombe:sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk'
MAYSUP='maya.ranscombe:fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b'
echo "######## staff basic auth"
for u in "$DEV" "$SUP" "$MAY"; do
  echo "--- $u"
  curl -sSk -m 10 --cacert $CA -u "$u" -w '\n[%{http_code}]\n' "$B/api/service-directory" | head -c 1200
done
echo "######## assistant conversation basic auth variants"
for u in "$DEV" "$SUP" "$MAY" "$MAYSUP"; do
  echo "--- $u"
  curl -sSk -m 10 --cacert $CA -u "$u" -w '\n[%{http_code}]\n' "$A/api/conversations/CONV-SUP-2841-19" | head -c 600
done
echo "######## assistant contexts basic"
curl -sSk -m 10 --cacert $CA -u "$DEV" -w '\n[%{http_code}]\n' "$A/api/contexts" | head -c 600
echo "######## staff unknown service ids (basic dev)"
for sid in assistant assistant.keplerops.test assistant-support fieldkest-assistant support-private; do
  echo "--- $sid"
  curl -sSk -m 10 --cacert $CA -u "$DEV" -X POST -H 'Content-Type: application/json' -d '{}' -w '\n[%{http_code}]\n' "$B/api/managed-identities/$sid/session" | head -c 600
done
echo "######## staff notes/archive with basic dev"
for p in /api/notes/ESC-SUP-2841-R3 /api/notes/2ddf90fa-67b2-4637-a1d9-19404b7bc234 /api/archive/handovers/2841 /api/archive/handovers/SUP-2841; do
  echo "--- $p"; curl -sSk -m 10 --cacert $CA -u "$DEV" -w '\n[%{http_code}]\n' "$B$p" | head -c 600
done
INNER
echo DONE_MARK_$RANDOM
