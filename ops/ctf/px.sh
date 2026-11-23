export PATH=/usr/sbin:/usr/bin:/sbin:/bin
pkill -f 'ssh .*-D 0.0.0.0:1080' 2>/dev/null
tmux kill-session -t pivot 2>/dev/null
cat > /tmp/pivot.sh <<'LOOP'
#!/bin/bash
export PATH=/usr/sbin:/usr/bin:/sbin:/bin
while true; do
  /usr/bin/ssh -o BatchMode=yes -o ExitOnForwardFailure=yes -o ServerAliveInterval=15 \
      -o ServerAliveCountMax=3 -o StrictHostKeyChecking=no -D 0.0.0.0:1080 -N rowan-dev 2>>/tmp/pivot.err
  echo "$(date +%T) exited rc=$?" >> /tmp/pivot.err
  sleep 2
done
LOOP
chmod +x /tmp/pivot.sh
setsid nohup /tmp/pivot.sh >/dev/null 2>&1 </dev/null &
sleep 6
echo "--- listen check:"; python3 -c "
import socket
s=socket.socket(); r=s.connect_ex(('127.0.0.1',1080)); print('port1080', 'OPEN' if r==0 else 'CLOSED')
"
echo "--- err:"; tail -3 /tmp/pivot.err 2>/dev/null || echo "(no err file)"
echo "--- test:"; curl -sS -m 15 --socks5-hostname 127.0.0.1:1080 -k -o /dev/null -w 'source=%{http_code} ' https://source.keplerops.test/; curl -sS -m 15 --socks5-hostname 127.0.0.1:1080 -k -o /dev/null -w 'ci=%{http_code}\n' https://ci.keplerops.test/
