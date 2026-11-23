set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
CA=/home/rowan/.local/share/keplerops/ca.crt
echo "=== sudo ==="; sudo -n -l 2>&1 | head -20
echo "=== grep cinder/delegat in home ==="; grep -ril --exclude-dir=.cache --exclude-dir=.local --exclude-dir=.config 'cinder\|delegat' /home/rowan 2>/dev/null | head -30
echo "=== work files ==="; find /home/rowan/work -maxdepth 2 -type f | sort
echo "=== support 8443 ==="
for p in / /api /api/v1 /health /openapi.json /api/delegations /delegations; do
 echo "--- $p"; curl -sS -m 6 --cacert $CA -i -H "Authorization: Bearer fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b" "https://support.keplerops.test:8443$p" 2>&1 | head -12
done
echo "=== staff board ==="
curl -sS -m 8 --cacert $CA -i https://staff.keplerops.test/ 2>&1 | head -20
echo "=== workboard ==="
curl -sS -m 8 --cacert $CA -i https://workboard.keplerops.test/ 2>&1 | head -20
INNER
