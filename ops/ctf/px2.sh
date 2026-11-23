export PATH=/usr/sbin:/usr/bin:/sbin:/bin
tmux kill-session -t p2 2>/dev/null
tmux kill-session -t pivot 2>/dev/null
cat > /tmp/loop.sh <<'LOOP'
#!/bin/bash
export PATH=/usr/sbin:/usr/bin:/sbin:/bin
while true; do
  /usr/bin/ssh -o BatchMode=yes -o ExitOnForwardFailure=yes -o ServerAliveInterval=15 -o ServerAliveCountMax=3 -o StrictHostKeyChecking=no -D 0.0.0.0:1080 -N rowan-dev 2>>/tmp/pivot.err
  echo "$(date +%T) ssh exited" >> /tmp/pivot.err
  sleep 2
done
LOOP
chmod +x /tmp/loop.sh
tmux new-session -d -s pivot /tmp/loop.sh
sleep 6
echo "--- port 1080:"; python3 -c "import socket;s=socket.socket();print('OPEN' if s.connect_ex(('127.0.0.1',1080))==0 else 'CLOSED')"
echo "--- ps:"; ps aux | grep -c "[s]sh .*-D 0.0.0.0:1080"
echo "--- proxy tests:"
for u in https://source.keplerops.test/ https://ci.keplerops.test/ https://packages.keplerops.test/ https://objects.keplerops.test/ https://assistant.keplerops.test/ https://review.keplerops.test/; do
  printf '%-42s ' "$u"; curl -sS -m 15 --socks5-hostname 127.0.0.1:1080 -k -o /dev/null -w '%{http_code}\n' "$u" 2>&1 | tail -1
done
