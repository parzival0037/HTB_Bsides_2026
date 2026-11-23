set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
echo "===== support-client.json ====="
cat ~/.config/fieldlink/support-client.json 2>/dev/null
echo
echo "===== assistant-ish configs ====="
ls -la ~/.config 2>/dev/null
find /home/rowan -maxdepth 4 -iname '*assistant*' 2>/dev/null | head -40
echo "===== grep assistant in work ====="
grep -ril 'assistant' /home/rowan/work 2>/dev/null | head -20
echo "===== platform-access.md ====="
cat /home/rowan/work/platform-access.md
echo "===== service-notes.md ====="
cat /home/rowan/work/service-notes.md
echo "===== identity-access.md ====="
cat /home/rowan/work/identity-access.md
echo "===== SUPPP ticket probe ====="
T="fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b"
for u in "https://support.keplerops.test/api/tickets/SUP-2841" "https://support.keplerops.test/api/tickets?ref=SUP-2841" "https://support.keplerops.test/scp/tickets.php?id=2841" "https://support.keplerops.test/api/tickets/REV-2841" "https://support.keplerops.test/scp/"; do
  echo "### $u"
  curl -sS -m 10 --cacert $CA -H "Authorization: Bearer $T" -o /tmp/o.txt -w '%{http_code} %{content_type} %{size_download}\n' "$u"
  head -c 1200 /tmp/o.txt; echo
done
INNER
