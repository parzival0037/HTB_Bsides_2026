SSH="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -i $HOME/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$SSH 'bash -s' <<'REMOTE'
which nmap || echo nonmap
nmap -sT -n -p80,443,8080,8443,8000,9000 --open -T4 --max-retries 1 --host-timeout 8s 10.77.60.0/24 2>/dev/null | grep -E "Nmap scan|open"
echo "=== 10.77.55.0/24"
nmap -sT -n -p80,443,8080,8443 --open -T4 --max-retries 1 --host-timeout 6s 10.77.55.0/24 2>/dev/null | grep -E "Nmap scan|open"
REMOTE
