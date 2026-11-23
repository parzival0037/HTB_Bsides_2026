#!/bin/bash
S="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$S 'cat > /tmp/as1.sh' <<'EOS'
#!/bin/bash
C="curl -sS -k --max-time 20"
for p in / /api/config /api/contexts /api/conversations /api/selections /static/app.js /.well-known/fieldkest-client /api/v1/workspaces; do
 echo "##### $p"
 $C -o /tmp/as -w '%{http_code} %{size_download}\n' "https://assistant.keplerops.test$p"
 head -c 600 /tmp/as; echo
done
EOS
chmod +x /tmp/as1.sh
$S 'bash /tmp/as1.sh' 2>&1 | head -120
