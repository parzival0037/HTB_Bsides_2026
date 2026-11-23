#!/bin/bash
S="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$S 'cat > /tmp/g4.sh' <<'EOS'
#!/bin/bash
for f in ~/repos/connector-archive/connector-archive/internal/fieldlink/legacy-diagnostics/CRR-OG2/ENG-FLK-LEGACY-42.md ~/repos/connector-archive/connector-archive/internal/fieldlink/legacy-diagnostics/CRR-OG2/ENT-ARWC-DIAG-0698.json ~/repos/connector-archive/connector-archive/notes/retained-diagnostic.md ~/repos/connector-archive/connector-archive/README.md; do
 echo "##### $f"; cat "$f"; echo
done
echo "##### samples"
ls -la ~/work/samples ~/work ~/work/previews ~/work/reproducers ~/work/registry 2>/dev/null
EOS
chmod +x /tmp/g4.sh
$S 'bash /tmp/g4.sh' 2>&1 | head -200
