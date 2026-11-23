#!/bin/bash
S="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$S 'cat > /tmp/kb4.sh' <<'EOS'
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
print(h[:4000])
print('LINKS:', [l for l in sorted(set(re.findall(r'href=\"([^\"]+)\"',open(sys.argv[1]).read()))) if 'task' in l or 'project' in l][:40])
" "$1"; }
echo "##### /list/1"
$C -o /tmp/l1 "https://workboard.keplerops.test/list/1"
txt /tmp/l1
echo "##### /board/1"
$C -o /tmp/b1 "https://workboard.keplerops.test/board/1"
grep -oE 'task_id=[0-9]+|/task/[0-9]+[^"]*' /tmp/b1 | sort -u | head -40
echo "##### project activity"
$C -o /tmp/pa "https://workboard.keplerops.test/project/1/activity"
txt /tmp/pa
echo "##### tasks search"
$C -o /tmp/ts "https://workboard.keplerops.test/?controller=TaskController&action=index&project_id=1"
grep -oE 'task_id=[0-9]+|/task/[0-9]+' /tmp/ts | sort -u | head
EOS
chmod +x /tmp/kb4.sh
$S 'bash /tmp/kb4.sh' 2>&1 | head -120
