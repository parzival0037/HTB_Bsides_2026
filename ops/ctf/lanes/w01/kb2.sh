#!/bin/bash
S="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$S 'cat > /tmp/kb2.sh' <<'EOS'
#!/bin/bash
C="curl -sS -k --max-time 20 -c /tmp/kbc -b /tmp/kbc -L"
rm -f /tmp/kbc
echo "### /login"
$C -o /tmp/kbl -w '%{http_code}\n' https://workboard.keplerops.test/login
form=$(grep -oE '<form[^>]*>' /tmp/kbl | head -3); echo "$form"
grep -oE '<input[^>]*>' /tmp/kbl | head -10
echo "### try POST /login"
$C -o /tmp/kbl2 -w '%{http_code}\n' -d "username=maya.ranscombe&password=sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk" https://workboard.keplerops.test/login
grep -oiE '<title>[^<]*|Dashboard|Projects|Logout|invalid' /tmp/kbl2 | sort -u | head
echo "### / (after login)"
$C -o /tmp/kbh -w '%{http_code}\n' https://workboard.keplerops.test/
grep -oiE 'href="[^"]+"' /tmp/kbh | sort -u | head -40
grep -oiE '<title>[^<]*' /tmp/kbh | head -3
echo "### project listing"
$C -o /tmp/kbpr -w '%{http_code}\n' "https://workboard.keplerops.test/project/1/board" 
head -c 400 /tmp/kbpr; echo
EOS
chmod +x /tmp/kb2.sh
$S 'bash /tmp/kb2.sh' 2>&1 | head -120
