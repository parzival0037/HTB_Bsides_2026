#!/bin/bash
set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=10 -i /home/cinder/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$S bash -s <<'REMOTE'
set +e
echo "== README"; cat ~/README.md; echo "== sj"; cat ~/sj.txt
echo "== repos tree"; find ~/repos ~/repos_k05 ~/work ~/k05arch -maxdepth 3 -printf '%y %10s %p\n' 2>/dev/null | head -100
echo "== grep content"
timeout 90 grep -rIl -E 'UsableVolume|RPT-CRR-DP3|allocation commitment|replacement-supply|replacement supply|planning window' /home /srv /opt /etc /var/lib /usr/local/share 2>/dev/null | head -40
echo "== name find"
timeout 60 find / -xdev \( -iname '*UsableVolume*' -o -iname '*allocation*' -o -iname '*tariff*' -o -iname '*planning*' -o -iname 'RPT-CRR*' \) 2>/dev/null | grep -v -E '^/(proc|sys)' | head -60
echo DONE_R7
REMOTE
