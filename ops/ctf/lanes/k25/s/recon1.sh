set -x
id; hostname; date
ls -la /tmp | head -50
tmux ls 2>&1
ss -ltnp 2>/dev/null | head -30
ls -la ~/.ssh/ 2>/dev/null
cat ~/.ssh/config 2>/dev/null
which curl jq python3 aws kubectl psql sshpass 2>/dev/null
curl -sS --socks5-hostname 127.0.0.1:1080 -k -m 20 -o /dev/null -w 'pivot source:%{http_code}\n' https://source.keplerops.test/
curl -sS --socks5-hostname 127.0.0.1:1080 -k -m 20 -o /dev/null -w 'pivot support:%{http_code}\n' https://support.keplerops.test/scp/
