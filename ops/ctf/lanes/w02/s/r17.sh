SSH="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -i $HOME/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$SSH 'bash -s' <<'REMOTE'
echo "### hosts"; cat /etc/hosts
scan(){ for i in $(seq 1 254); do for p in 80 443 8443; do (timeout 0.5 bash -c "</dev/tcp/$1.$i/$p" 2>/dev/null && echo "$1.$i:$p open") & done; done; wait; }
echo "### 10.77.51"
scan 10.77.51 2>/dev/null | sort -V
echo "### 10.77.50"
scan 10.77.50 2>/dev/null | sort -V
REMOTE
