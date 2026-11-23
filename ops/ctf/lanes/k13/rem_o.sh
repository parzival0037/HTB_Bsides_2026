set +e
B=https://staff.keplerops.test
U='maya.ranscombe:sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk'
echo "== staff root =="
curl -sSk -m 8 -i "$B/" | head -25
echo "== directory no auth =="
curl -sSk -m 8 -i "$B/api/service-directory" | head -30
echo "== directory basic =="
curl -sSk -m 8 -i -u "$U" "$B/api/service-directory" | head -40
echo "== directory basic 2 =="
curl -sSk -m 8 -i -u 'rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo' "$B/api/service-directory" | head -20
echo "== directory support bearer =="
curl -sSk -m 8 -i -H 'Authorization: Bearer fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b' "$B/api/service-directory" | head -20
echo "== notes guesses =="
for n in 1 SUP-2841 workspace EXP-2841 K13 k13 fieldkest-workspaces handover note-1; do
  echo "-- $n"; curl -sSk -m 6 -o /tmp/n -u "$U" -w '%{http_code}\n' "$B/api/notes/$n"; head -c 300 /tmp/n; echo
done
echo "== archive guesses =="
for s in workspace EXP-2841 support-export support handover handovers fieldkest-workspaces SUP-2841; do
  echo "-- $s"; curl -sSk -m 6 -o /tmp/a -u "$U" -w '%{http_code}\n' "$B/api/archive/handovers/$s"; head -c 400 /tmp/a; echo
done
