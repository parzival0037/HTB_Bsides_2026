#!/bin/bash
ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180 'bash -s' <<'INNER'
which nmap masscan nc socat 2>/dev/null
echo "=== quick scan 10.77.60.0/24 + 61/24 + 62/24 ==="
scanport(){ (timeout 2 bash -c "echo > /dev/tcp/$1/$2" 2>/dev/null && echo "OPEN $1:$2") ; }
export -f scanport
for net in 10.77.60 10.77.61 10.77.62 10.77.63; do
  for i in $(seq 1 254); do for p in 22 80 443 3000 5000 8000 8080 8443 8888 9090 3389 5432; do echo "$net.$i $p"; done; done
done | xargs -P 200 -n 2 bash -c 'scanport $0 $1'
echo SCANDONE
INNER
