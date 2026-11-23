#!/bin/bash
S="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$S 'cat > /tmp/pscan.sh' <<'EOS'
#!/bin/bash
for p in $(seq 1 65535); do
 ( timeout 1 bash -c "echo >/dev/tcp/10.77.60.20/$p" 2>/dev/null && echo "open $p" ) &
 while [ $(jobs -r | wc -l) -ge 256 ]; do wait -n; done
done
wait
EOS
chmod +x /tmp/pscan.sh
$S 'timeout 500 bash /tmp/pscan.sh' 2>&1 | sort -n | head -40
