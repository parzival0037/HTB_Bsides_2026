set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
CA=/home/rowan/.local/share/keplerops/ca.crt
B=https://support.keplerops.test
J=/tmp/ck4.txt; rm -f $J
curl -sS -m 10 --cacert $CA -c $J -b $J "$B/scp/pwreset.php?token=k17-talia-mornac-review-token-2841" -o /tmp/pw.html
echo "=== FULL RESET HTML (body) ==="
cat /tmp/pw.html | sed -n '1,200p'
INNER
