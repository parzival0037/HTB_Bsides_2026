#!/bin/bash
S="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$S 'cat > /tmp/b3.sh' <<'EOS'
#!/bin/bash
C="curl -sS -k --max-time 15"
echo "##### service-directory"
$C -i https://staff.keplerops.test/api/service-directory | head -c 4000; echo
echo "##### cloud maintenance"
$C -i https://cloud-api.keplerops.test/api/maintenance | head -c 3000; echo
echo "##### archive handovers probe"
for s in arwc ARWC arwc-fieldlink crr-og2 CRR-OG2 cairn-reach cairnreach fieldlink SUP-2841 sup-2841 rowan.ito maya.ranscombe customer supplier planning; do
  echo "--- $s"; $C -o /tmp/a -w '%{http_code} ' "https://staff.keplerops.test/api/archive/handovers/$s"; head -c 500 /tmp/a; echo
done
echo "##### notes probe"
for n in 1 NOTE-SUP-2841-7 SUP-2841 note-sup-2841-7; do echo "--- $n"; $C -o /tmp/a -w '%{http_code} ' "https://staff.keplerops.test/api/notes/$n"; head -c 300 /tmp/a; echo; done
EOS
chmod +x /tmp/b3.sh
$S 'bash /tmp/b3.sh' 2>&1 | head -200
