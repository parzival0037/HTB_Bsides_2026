set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
echo "===== /etc/hosts ====="; $S 'cat /etc/hosts'
echo "===== ip ====="; $S 'ip -4 a; ip r'
echo "===== resolve ====="; $S 'for h in source.keplerops.test packages.keplerops.test data.keplerops.test fieldlink.keplerops.test workboard.keplerops.test git.keplerops.test; do printf "%-32s " $h; getent hosts $h || echo FAIL; done'
echo "===== listening ====="; $S 'ss -ltnp 2>/dev/null || netstat -ltn'
echo "===== home ====="; $S 'ls -la ~; echo ---; ls -la ~/work 2>/dev/null | head -40'
echo "===== ssh known_hosts + config ====="; $S 'cat ~/.ssh/config 2>/dev/null; echo ---; cut -d\  -f1 ~/.ssh/known_hosts 2>/dev/null | tr "," "\n" | sort -u | head -40'
echo "===== env ====="; $S 'env | grep -i -E "proxy|keplerops|token|url" | head -20'
