S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'RSH'
set +e
echo "=== disk before"; df -h / /home 2>&1 | tail -3
ls -la /home/rowan/core 2>&1
rm -f /home/rowan/core
echo "=== disk after"; df -h / /home 2>&1 | tail -3
R=/home/rowan/repos/connector-archive
echo "=== README"; cat $R/README.md
echo "=== notes/retained-diagnostic.md"; cat $R/notes/retained-diagnostic.md
echo "=== ENG-FLK-LEGACY-42.md"; cat $R/internal/fieldlink/legacy-diagnostics/CRR-OG2/ENG-FLK-LEGACY-42.md
echo "=== ENT json"; cat $R/internal/fieldlink/legacy-diagnostics/CRR-OG2/ENT-ARWC-DIAG-0698.json
echo "=== config"; cat $R/config/ordinary.conf; echo; cat $R/config/diagnostic.conf
echo "=== grep FLAG all repos"; grep -rIn "FLAG{" /home/rowan/repos /home/rowan/repos_k05 2>/dev/null | head -20
RSH
