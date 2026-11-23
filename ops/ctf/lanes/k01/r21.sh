set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'RSH'
set +e
echo "===SSHD CFG==="; grep -vE '^\s*#|^\s*$' /etc/ssh/sshd_config 2>&1 | head -40; ls -la /etc/ssh/sshd_config.d 2>&1; cat /etc/ssh/sshd_config.d/* 2>&1 | head -20
echo "===TOOLS==="; which socat nc ncat python3 ssh
echo "===LISTEN==="; ss -tlnp 2>/dev/null | head
RSH
