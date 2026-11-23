export PATH=/usr/sbin:/usr/bin:/sbin:/bin
tmux kill-session -t relay 2>/dev/null; tmux kill-session -t pivot 2>/dev/null
cat > /tmp/relay.sh <<'R'
#!/bin/bash
export PATH=/usr/sbin:/usr/bin:/sbin:/bin
while true; do
  /usr/bin/ssh -o BatchMode=yes -o ServerAliveInterval=15 -o ServerAliveCountMax=3 -o StrictHostKeyChecking=no rowan-dev 'python3 /tmp/s5.py 13389' 2>>/tmp/relay.err
  sleep 2
done
R
cat > /tmp/fwd.sh <<'F'
#!/bin/bash
export PATH=/usr/sbin:/usr/bin:/sbin:/bin
while true; do
  /usr/bin/ssh -o BatchMode=yes -o ExitOnForwardFailure=yes -o ServerAliveInterval=15 -o ServerAliveCountMax=3 -o StrictHostKeyChecking=no -N -L 0.0.0.0:1080:127.0.0.1:13389 rowan-dev 2>>/tmp/fwd.err
  sleep 2
done
F
tmux new-session -d -s relay "bash /tmp/relay.sh"
sleep 3
tmux new-session -d -s pivot "bash /tmp/fwd.sh"
sleep 5
echo "--- sessions:"; tmux ls
echo "--- listen:"; python3 -c "import socket;s=socket.socket();print('1080', 'OPEN' if s.connect_ex(('127.0.0.1',1080))==0 else 'CLOSED')"
echo "--- tests:"
for u in https://source.keplerops.test/ https://ci.keplerops.test/ https://packages.keplerops.test/ https://objects.keplerops.test/ https://assistant.keplerops.test/ https://review.keplerops.test/ https://cloud-api.keplerops.test:6443/ https://support.keplerops.test/; do
  printf '%-44s ' "$u"; curl -sS -m 12 --socks5-hostname 127.0.0.1:1080 -k -o /dev/null -w '%{http_code}\n' "$u" 2>&1 | tail -1
done
