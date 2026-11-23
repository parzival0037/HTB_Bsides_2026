set +e
echo "===BOX HOSTS==="; cat /etc/hosts; getent hosts
echo "===BOX RESOLV==="; cat /etc/resolv.conf
echo "===SSH CFG==="; cat ~/.ssh/config 2>/dev/null; ls -la ~/.ssh
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'RSH'
set +e
echo "===HOSTNAME/IP==="; hostname; ip -4 a | grep -E 'inet |^[0-9]'
echo "===HOSTS==="; cat /etc/hosts
echo "===RESOLV==="; cat /etc/resolv.conf
echo "===SSH CONFIGS==="; ls -la ~/.ssh; cat ~/.ssh/config 2>/dev/null
echo "===KEPLER DIR==="; find ~/.local/share/keplerops -maxdepth 3 2>/dev/null | head -50
echo "===CA==="; ls -la /home/rowan/.local/share/keplerops/ca.crt 2>/dev/null
RSH
