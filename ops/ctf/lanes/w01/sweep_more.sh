#!/bin/bash
S="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$S 'cat > /tmp/scan2.sh' <<'EOS'
#!/bin/bash
for net in 50 51 52 53 54 55 56 57 58 59 61 62; do
 for i in $(seq 1 254); do
  ip=10.77.$net.$i
  for p in 80 443 8080 8443; do
   ( timeout 1 bash -c "echo >/dev/tcp/$ip/$p" 2>/dev/null && echo "$ip:$p" ) &
   while [ $(jobs -r | wc -l) -ge 128 ]; do wait -n; done
  done
 done
done
wait
EOS
chmod +x /tmp/scan2.sh
$S 'timeout 600 bash /tmp/scan2.sh' 2>&1 | sort -u
