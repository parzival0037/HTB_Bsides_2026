SSH="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -i $HOME/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$SSH 'bash -s' <<'REMOTE'
scan(){ for i in $(seq 1 254); do for p in 80 443 8080 8443 8000 9000 5432 6443; do (timeout 0.6 bash -c "</dev/tcp/10.77.60.$i/$p" 2>/dev/null && echo "10.77.60.$i:$p open") & done; done; wait; }
scan 2>/dev/null | sort -V
REMOTE
