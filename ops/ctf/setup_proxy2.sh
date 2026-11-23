set +e
# resilient SOCKS pivot: restart loop in tmux, survives transient ssh drops
tmux kill-session -t k01socks 2>/dev/null
tmux kill-session -t pivot 2>/dev/null
tmux new-session -d -s pivot 'while true; do ssh -o BatchMode=yes -o ExitOnForwardFailure=yes -o ServerAliveInterval=15 -o ServerAliveCountMax=3 -o StrictHostKeyChecking=no -D 0.0.0.0:1080 -N rowan-dev; sleep 2; done'
sleep 4
echo "--- listeners:"; ss -ltn | grep 1080
echo "--- test:"; curl -sS -m 12 --socks5-hostname 127.0.0.1:1080 -k -o /dev/null -w 'source=%{http_code} ' https://source.keplerops.test/ ; curl -sS -m 12 --socks5-hostname 127.0.0.1:1080 -k -o /dev/null -w 'pkg=%{http_code}\n' https://packages.keplerops.test/
echo "--- tmux:"; tmux ls
