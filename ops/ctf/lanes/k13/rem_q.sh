set +e
B=https://staff.keplerops.test
U='rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'
echo "== directory full =="
curl -sSk -m 8 -w '\n[HTTP %{http_code}]\n' -u "$U" "$B/api/service-directory" | head -c 8000; echo
echo "== notes =="
for n in NOTE-SUP-2841-7 SUP-2841 workspace; do
  echo "-- $n"; curl -sSk -m 6 -o /tmp/n -u "$U" -w '%{http_code}\n' "$B/api/notes/$n"; head -c 800 /tmp/n; echo
done
echo "== archive with basic (expect cert req) =="
curl -sSk -m 6 -o /tmp/a -u "$U" -w '%{http_code}\n' "$B/api/archive/handovers/workspace"; head -c 400 /tmp/a; echo
echo "== managed identity session guesses =="
for s in workspace objects cloud-api data fieldlink-workspace fieldkest-workspaces object-storage; do
  echo "-- $s"; curl -sSk -m 6 -o /tmp/m -u "$U" -X POST -H 'Content-Type: application/json' -d '{}' -w '%{http_code}\n' "$B/api/managed-identities/$s/session"; head -c 500 /tmp/m; echo
done
