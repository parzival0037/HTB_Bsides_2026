S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'RSH'
df -h; echo; df -i; echo "=== mounts"; mount | grep -E " / | /tmp | /home " ; echo "=== big files"; du -xsh /tmp/* 2>/dev/null | sort -h | tail -10; ls -la /home/rowan/core 2>&1; echo "=== /tmp files"; ls -la /tmp | head -30
RSH
