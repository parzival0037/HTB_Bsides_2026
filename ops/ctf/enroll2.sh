set +e
P="curl -sS -m 15 --socks5-hostname 127.0.0.1:1080 -k"
echo "=== GET enrollment template (no auth) ==="
$P https://staff.keplerops.test/api/enrollment/StaffArchiveUser; echo
echo "=== ca health / root ==="
$P -o /dev/null -w 'ca root  %{http_code}\n' https://ca.keplerops.test/root/2026
$P -o /dev/null -w 'ca health %{http_code}\n' https://ca.keplerops.test/health
echo "=== step on rowan-dev ==="
ssh -o BatchMode=yes rowan-dev 'which step; step version 2>&1 | head -2; ls -la ~/.step 2>/dev/null | head -5; cat ~/.step/config/defaults.json 2>/dev/null | head -20'
