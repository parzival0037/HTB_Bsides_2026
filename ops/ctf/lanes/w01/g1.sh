#!/bin/bash
S="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$S 'cat > /tmp/g1.sh' <<'EOS'
#!/bin/bash
C="curl -sS -k --max-time 20"
D="rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
echo "### user repos"
$C -u "$D" "https://source.keplerops.test/api/v1/user/repos?limit=100&page=1" | python3 -c "
import sys,json
d=json.load(sys.stdin)
for r in d: print(r['full_name'],'|',r.get('description'))"
echo "### search repos q=arwc"
$C -u "$D" "https://source.keplerops.test/api/v1/repos/search?q=arwc&limit=50" | python3 -c "
import sys,json; d=json.load(sys.stdin)
for r in d.get('data',[]): print(r['full_name'],'|',r.get('description'))"
echo "### search repos q=cairn"
$C -u "$D" "https://source.keplerops.test/api/v1/repos/search?q=cairn&limit=50" | python3 -c "
import sys,json; d=json.load(sys.stdin)
for r in d.get('data',[]): print(r['full_name'],'|',r.get('description'))"
echo "### org list"
$C -u "$D" "https://source.keplerops.test/api/v1/user/orgs" | head -c 800; echo
echo "### global search code? (may 404)"
$C -u "$D" "https://source.keplerops.test/api/v1/repos/search?q=water&limit=20" | head -c 600; echo
EOS
chmod +x /tmp/g1.sh
$S 'bash /tmp/g1.sh' 2>&1 | head -160
