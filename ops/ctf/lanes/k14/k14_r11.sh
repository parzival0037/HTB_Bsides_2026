set +e
ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=8 rowan-dev 'bash -s' <<'RSH'
set +e
E=https://objects.keplerops.test
for k in exports/EXP-2841/handover.json notebooks/deploy-2026-09.json; do
 echo "##### $k"
 curl -sSk -m 10 "$E/fieldkest-workspaces/$k" | tee /tmp/obj.json
 echo; echo "--- sha256"; sha256sum /tmp/obj.json
done
echo "=== list exports/ prefix ==="
curl -sSk -m 10 "$E/fieldkest-workspaces/?list-type=2&prefix=exports/" | head -c 3000; echo
curl -sSk -m 10 "$E/fieldkest-workspaces/?list-type=2&prefix=notebooks/" | head -c 2000; echo
echo "=== versions ==="
curl -sSk -m 10 "$E/fieldkest-workspaces/?versions" | head -c 3000; echo
RSH
echo DONE_K14_R11
