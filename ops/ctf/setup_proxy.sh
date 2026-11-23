set +e
# persistent SOCKS5 pivot through rowan-dev on the range box
tmux kill-session -t pivot 2>/dev/null
tmux new-session -d -s pivot 'ssh -o BatchMode=yes -o ExitOnForwardFailure=yes -o ServerAliveInterval=20 -D 0.0.0.0:1080 -N rowan-dev'
sleep 3
echo "--- tmux:"; tmux ls
echo "--- proxy test (source.keplerops.test via socks5):"
curl -sS -m 12 --socks5-hostname 127.0.0.1:1080 -k -o /dev/null -w 'source http=%{http_code}\n' https://source.keplerops.test/
curl -sS -m 12 --socks5-hostname 127.0.0.1:1080 -k -o /dev/null -w 'ci     http=%{http_code}\n' https://ci.keplerops.test/
curl -sS -m 12 --socks5-hostname 127.0.0.1:1080 -k -o /dev/null -w 'pkg    http=%{http_code}\n' https://packages.keplerops.test/
echo "--- CA cert export:"
ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev 'cat /home/rowan/.local/share/keplerops/ca.crt' > /tmp/keplerops-ca.crt
wc -l /tmp/keplerops-ca.crt; head -2 /tmp/keplerops-ca.crt
