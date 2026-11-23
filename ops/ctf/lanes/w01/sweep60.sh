#!/bin/bash
S="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$S 'cat > /tmp/scan.sh' <<'EOS'
#!/bin/bash
sweep(){
 for i in $(seq 1 254); do
  ip=10.77.60.$i
  for p in 22 80 443 3000 5000 8000 8080 8081 8443 5432 6379 9000 9200 13389 5601 8082 8083 9090; do
   ( timeout 1 bash -c "echo >/dev/tcp/$ip/$p" 2>/dev/null && echo "$ip:$p" ) &
   while [ $(jobs -r | wc -l) -ge 64 ]; do wait -n; done
  done
 done
 wait
}
sweep
EOS
chmod +x /tmp/scan.sh
echo "### sweep start"
$S 'timeout 300 bash /tmp/scan.sh' 2>&1 | sort -u
echo "### done"
