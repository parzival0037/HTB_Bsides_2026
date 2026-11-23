S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'RSH'
set +e
cd /home/rowan && rm -rf ktmp && mkdir ktmp && cd ktmp && unzip -o -q /home/rowan/repos/connector-archive.zip
echo "=== files"; find . -type f | head -40
echo "=== README"; cat connector-archive/README.md
echo "=== retained-diagnostic"; cat connector-archive/notes/retained-diagnostic.md
echo "=== ENG-FLK-LEGACY-42"; cat connector-archive/internal/fieldlink/legacy-diagnostics/CRR-OG2/ENG-FLK-LEGACY-42.md
echo "=== ENT json"; cat connector-archive/internal/fieldlink/legacy-diagnostics/CRR-OG2/ENT-ARWC-DIAG-0698.json
echo "=== configs"; for f in connector-archive/config/*.conf; do echo "--- $f"; cat "$f"; done
echo "=== grep FLAG"; grep -rIn "FLAG{" . | head -20
echo "=== connector-archive-review.md"; cat /home/rowan/work/build-operations/connector-archive-review.md
echo "=== /tmp/arwc_key"; head -c 600 /tmp/arwc_key; echo
RSH
