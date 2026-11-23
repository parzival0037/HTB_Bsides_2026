#!/bin/bash
S="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$S 'cat > /tmp/kb3.sh' <<'EOS'
#!/bin/bash
C="curl -sS -k --max-time 20 -c /tmp/kbc -b /tmp/kbc"
rm -f /tmp/kbc
$C -o /tmp/kbl https://workboard.keplerops.test/login
CSRF=$(grep -oP 'name="csrf_token" value="\K[^"]+' /tmp/kbl | head -1)
echo "csrf=$CSRF"
$C -o /tmp/kbr -D /tmp/kbhdr -w 'LOGIN %{http_code} -> %{redirect_url}\n' -d "username=maya.ranscombe&password=sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk&csrf_token=$CSRF" https://workboard.keplerops.test/login/check
head -20 /tmp/kbhdr
echo "### root"
$C -o /tmp/kbroot -w '%{http_code}\n' https://workboard.keplerops.test/
sed -n '1,40p' /tmp/kbroot
echo "### text"
python3 - <<'PY'
import re
h=open('/tmp/kbroot').read()
txt=re.sub(r'<script.*?</script>|<style.*?</style>','',h,flags=re.S)
txt=re.sub(r'<[^>]+>',' ',txt)
txt=re.sub(r'\s+',' ',txt)
print(txt[:2500])
print('LINKS', sorted(set(re.findall(r'href="([^"]+)"',h)))[:60])
PY
echo "### api probes"
for u in /api/v1/projects /api/v1/user /api/v1/info /api/v1/tasks /projects; do
  echo "--- $u"; $C -o /tmp/kba -w '%{http_code} ' "https://workboard.keplerops.test$u"; head -c 400 /tmp/kba; echo
done
EOS
chmod +x /tmp/kb3.sh
$S 'bash /tmp/kb3.sh' 2>&1 | head -150
