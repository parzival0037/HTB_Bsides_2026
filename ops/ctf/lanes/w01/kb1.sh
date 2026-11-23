#!/bin/bash
S="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$S 'cat > /tmp/kb.sh' <<'EOS'
#!/bin/bash
C="curl -sS -k --max-time 20 -c /tmp/kbc -b /tmp/kbc"
rm -f /tmp/kbc
echo "### login page"
$C -o /tmp/kbl -w '%{http_code}\n' https://workboard.keplerops.test/
grep -oiE '<form[^>]*>|<input[^>]*>|name="[^"]*"' /tmp/kbl | head -20
CSRF=$(grep -oP 'name="csrf_token" value="\K[^"]+' /tmp/kbl | head -1)
echo "csrf=$CSRF"
echo "### login"
$C -o /tmp/kbl2 -w '%{http_code}\n' -L -d "username=maya.ranscombe&password=sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk&csrf_token=$CSRF" "https://workboard.keplerops.test/?controller=AuthController&action=check"
head -c 500 /tmp/kbl2; echo
echo "### dashboard"
$C -o /tmp/kbd -w '%{http_code}\n' https://workboard.keplerops.test/?controller=DashboardController&action=show
grep -oiE 'href="[^"]*"|title>[^<]*' /tmp/kbd | sort -u | head -60
echo "### my projects"
$C -o /tmp/kbp -w '%{http_code}\n' "https://workboard.keplerops.test/?controller=ProjectController&action=index"
grep -oiE 'href="[^"]*"|>[A-Za-z][^<]{2,40}<' /tmp/kbp | sort -u | head -60
EOS
chmod +x /tmp/kb.sh
$S 'bash /tmp/kb.sh' 2>&1 | head -120
