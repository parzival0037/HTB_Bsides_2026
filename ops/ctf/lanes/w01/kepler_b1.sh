#!/bin/bash
S="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$S 'cat > /tmp/b1.sh' <<'EOS'
#!/bin/bash
C="curl -sS -k --max-time 15"
echo "##### workboard root"; $C https://workboard.keplerops.test/ | head -c 1500; echo
echo "##### workboard api"; for p in api api/ api/boards api/v1/boards api/reviews api/handovers api/documents; do echo "--- $p"; $C -o /tmp/w -w '%{http_code} ' "https://workboard.keplerops.test/$p"; head -c 300 /tmp/w; echo; done
echo "##### staff root"; $C https://staff.keplerops.test/ | head -c 800; echo
echo "##### assistant workspaces"; $C https://assistant.keplerops.test/api/v1/workspaces | head -c 1000; echo
echo "##### s3 buckets"; aws --endpoint-url https://objects.keplerops.test s3 ls 2>&1 | head -30
echo "##### s3 fieldlink-exports"; aws --endpoint-url https://objects.keplerops.test s3 ls s3://fieldlink-exports 2>&1 | head -30
EOS
chmod +x /tmp/b1.sh
$S 'bash /tmp/b1.sh' 2>&1 | head -120
