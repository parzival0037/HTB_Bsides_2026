#!/bin/bash
S="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$S 'cat > /tmp/b2.sh' <<'EOS'
#!/bin/bash
C="curl -sS -k --max-time 15"
for h in workboard staff tickets assistant data objects cloud-api indexer source support review source-tools; do
  echo "##### $h"
  $C -o /tmp/wk -w '%{http_code}\n' "https://$h.keplerops.test/.well-known/fieldkest-client"
  head -c 2500 /tmp/wk; echo
done
echo "##### workboard root verbose"
$C -i https://workboard.keplerops.test/ 2>&1 | head -40
echo "##### staff root verbose"
$C -i https://staff.keplerops.test/ 2>&1 | head -40
EOS
chmod +x /tmp/b2.sh
$S 'bash /tmp/b2.sh' 2>&1 | head -250
