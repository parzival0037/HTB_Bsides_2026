#!/bin/bash
echo "== tmux =="
tmux ls 2>&1
echo "== ps =="
ps aux | grep -E 'ssh -N|s5.py|fwd.sh|relay.sh' | grep -v grep
echo "== scripts =="
ls -l /tmp/fwd.sh /tmp/relay.sh /tmp/s5.py 2>&1
cat /tmp/fwd.sh 2>/dev/null; echo ---; cat /tmp/relay.sh 2>/dev/null
