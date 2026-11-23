#!/bin/bash
S="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$S 'cat > /tmp/g2.sh' <<'EOS'
#!/bin/bash
C="curl -sS -k --max-time 20"
D="rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
for r in fieldkest/connector-archive fieldkest/fieldlink-connector fieldkest/policy-compiler fieldkest/release-signer-history; do
 echo "##### ISSUES $r"
 $C -u "$D" "https://source.keplerops.test/api/v1/repos/$r/issues?state=all&limit=50&type=issues" | python3 -c "
import sys,json
d=json.load(sys.stdin)
for i in d:
  print('--- #%s [%s] %s (labels=%s)'%(i['number'],i['state'],i['title'],[l['name'] for l in i.get('labels',[])]))
  print(i['body'])
" 2>&1
 echo "##### PULLS $r"
 $C -u "$D" "https://source.keplerops.test/api/v1/repos/$r/pulls?state=all&limit=50" | python3 -c "
import sys,json
d=json.load(sys.stdin)
for i in d: print('PR #%s [%s] %s'%(i['number'],i['state'],i['title']))
  " 2>&1
done
EOS
chmod +x /tmp/g2.sh
$S 'bash /tmp/g2.sh' 2>&1 | head -250
