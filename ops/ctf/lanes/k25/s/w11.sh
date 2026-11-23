S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'RSH'
set +e
cd /tmp && rm -rf ca && mkdir ca && cd ca && unzip -o -q /home/rowan/repos/connector-archive.zip
echo "=== files"; find . -type f | head -40
echo "=== README"; cat */README.md 2>/dev/null | head -60
echo "=== retained-diagnostic"; cat */notes/retained-diagnostic.md 2>/dev/null
echo "=== ENG-FLK-LEGACY-42"; cat */internal/fieldlink/legacy-diagnostics/CRR-OG2/ENG-FLK-LEGACY-42.md 2>/dev/null
echo "=== ENT json"; cat */internal/fieldlink/legacy-diagnostics/CRR-OG2/ENT-ARWC-DIAG-0698.json 2>/dev/null
echo "=== configs"; cat */config/*.conf 2>/dev/null
echo "=== grep FLAG"; grep -rIn "FLAG{" . 2>/dev/null | head -20
RSH
