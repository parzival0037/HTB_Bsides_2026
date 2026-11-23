#!/bin/bash
S="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$S 'cat > /tmp/g3.sh' <<'EOS'
#!/bin/bash
C="curl -sS -k --max-time 25"
D="rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
for r in fieldkest/connector-archive fieldkest/fieldlink-connector fieldkest/policy-compiler fieldkest/release-signer-history; do
 echo "##### TREE $r"
 $C -u "$D" "https://source.keplerops.test/api/v1/repos/$r/git/trees/HEAD?recursive=1&per_page=1000" | python3 -c "
import sys,json
d=json.load(sys.stdin)
for t in d.get('tree',[]):
  if t['type']=='blob': print(t['path'])
" 2>&1 | head -80
done
EOS
chmod +x /tmp/g3.sh
$S 'bash /tmp/g3.sh' 2>&1 | head -200
