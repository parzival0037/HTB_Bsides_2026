#!/bin/bash
S="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$S 'cat > /tmp/kb5.sh' <<'EOS'
#!/bin/bash
C="curl -sS -k --max-time 20 -c /tmp/kbc -b /tmp/kbc"
rm -f /tmp/kbc
$C -o /tmp/kbl https://workboard.keplerops.test/login
CSRF=$(grep -oP 'name="csrf_token" value="\K[^"]+' /tmp/kbl | head -1)
$C -o /dev/null -d "username=maya.ranscombe&password=sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk&csrf_token=$CSRF" https://workboard.keplerops.test/login/check
txt(){ python3 -c "
import re,sys
h=open(sys.argv[1]).read()
h=re.sub(r'<script.*?</script>|<style.*?</style>','',h,flags=re.S)
h=re.sub(r'<[^>]+>',' ',h); h=re.sub(r'&nbsp;',' ',h); h=re.sub(r'\s+',' ',h)
print(h[:3500])
" "$1"; }
for u in "/projects" "/?controller=ProjectListController&action=show" "/?controller=UserListController&action=show" "/user/show/3" "/?controller=ProjectController&action=share&project_id=1" "/?controller=ProjectPermissionController&action=index&project_id=1"; do
  echo "##### $u"
  $C -o /tmp/kg -w '%{http_code}\n' "https://workboard.keplerops.test$u"
  txt /tmp/kg
done
EOS
chmod +x /tmp/kb5.sh
$S 'bash /tmp/kb5.sh' 2>&1 | sed -n '/#####/,$p' | head -120
