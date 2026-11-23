export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
set +e
tmux kill-session -t pivot 2>/dev/null; tmux kill-session -t k01socks 2>/dev/null
pkill -f 'ssh .*-D 0.0.0.0:1080' 2>/dev/null
sleep 1
cat > /tmp/pivot.sh <<'LOOP'
#!/bin/bash
while true; do
  ssh -o BatchMode=yes -o ExitOnForwardFailure=yes -o ServerAliveInterval=15 \
      -o ServerAliveCountMax=3 -o StrictHostKeyChecking=no \
      -D 0.0.0.0:1080 -N rowan-dev 2>>/tmp/pivot.err
  echo "$(date +%T) ssh exited rc=$?" >> /tmp/pivot.err
  sleep 2
done
LOOP
chmod +x /tmp/pivot.sh
tmux new-session -d -s pivot /tmp/pivot.sh
sleep 5
echo "--- listener:"; ss -ltn | grep 1080 || echo "NO LISTENER"
echo "--- err:"; tail -4 /tmp/pivot.err 2>/dev/null
echo "--- test:"; curl -sS -m 15 --socks5-hostname 127.0.0.1:1080 -k -o /dev/null -w 'source=%{http_code} ' https://source.keplerops.test/; curl -sS -m 15 --socks5-hostname 127.0.0.1:1080 -k -o /dev/null -w 'pkg=%{http_code}\n' https://packages.keplerops.test/
