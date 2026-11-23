export PATH=/usr/sbin:/usr/bin:/sbin:/bin
# 1) ensure a supervised socks5 relay on rowan-dev:13389
cat lanes/k01/socks5.py > /tmp/s5.py 2>/dev/null || true
ssh -o BatchMode=yes rowan-dev 'cat > /tmp/s5.py' < /home/kali/ctf/lanes/k01/socks5.py
ssh -o BatchMode=yes rowan-dev 'pkill -f "socks5.py 13389"; sleep 1; nohup python3 /tmp/s5.py 13389 >/tmp/s5.log 2>&1 & sleep 2; python3 -c "import socket;s=socket.socket();print(\"relay:\",\"OPEN\" if s.connect_ex((\"127.0.0.1\",13389))==0 else \"CLOSED\")"'
# 2) local -L forward on the range box, supervised in tmux
tmux kill-session -t pivot 2>/dev/null
cat > /tmp/fwd.sh <<'LOOP'
#!/bin/bash
export PATH=/usr/sbin:/usr/bin:/sbin:/bin
while true; do
  /usr/bin/ssh -o BatchMode=yes -o ExitOnForwardFailure=yes -o ServerAliveInterval=15 -o ServerAliveCountMax=3 -o StrictHostKeyChecking=no -N -L 0.0.0.0:1080:127.0.0.1:13389 rowan-dev 2>>/tmp/fwd.err
  sleep 2
done
LOOP
tmux new-session -d -s pivot "bash /tmp/fwd.sh"
sleep 5
python3 -c "import socket;s=socket.socket();print('local1080:', 'OPEN' if s.connect_ex(('127.0.0.1',1080))==0 else 'CLOSED')"
echo "--- tests:"
for u in https://source.keplerops.test/ https://ci.keplerops.test/ https://packages.keplerops.test/ https://objects.keplerops.test/ https://assistant.keplerops.test/ https://review.keplerops.test/ https://cloud-api.keplerops.test:6443/; do
  printf '%-44s ' "$u"; curl -sS -m 12 --socks5-hostname 127.0.0.1:1080 -k -o /dev/null -w '%{http_code}\n' "$u" 2>&1 | tail -1
done
