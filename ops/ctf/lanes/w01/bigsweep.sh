#!/bin/bash
S="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$S 'cat > /tmp/bs.sh' <<'IN'
#!/bin/bash
probe(){ ip=$1; for p in 80 443 8080 8443; do ( timeout 0.6 bash -c "echo >/dev/tcp/$ip/$p" 2>/dev/null && echo "$ip:$p" ) & done; while [ $(jobs -r|wc -l) -ge 400 ]; do wait -n; done; }
for third in 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80; do
 for i in $(seq 1 254); do probe 10.77.$third.$i; done
 wait
done
IN
chmod +x /tmp/bs.sh
$S 'timeout 900 bash /tmp/bs.sh' 2>&1 | sort -u -t. -k3,3n -k4,4 | head -80
