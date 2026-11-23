set +e
B=https://staff.keplerops.test
U='maya.ranscombe:sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk'
echo "== directory basic full =="
curl -sSk -m 8 -w '\n[HTTP %{http_code}]\n' -u "$U" "$B/api/service-directory" | tee /tmp/dir.json | head -c 6000; echo
echo "== root basic =="
curl -sSk -m 8 -i -u "$U" "$B/" | head -30
echo "== notes basic =="
for n in NOTE-SUP-2841-7 SUP-2841 2841; do
  echo "-- $n"; curl -sSk -m 6 -o /tmp/n -u "$U" -w '%{http_code}\n' "$B/api/notes/$n"; head -c 500 /tmp/n; echo
done
