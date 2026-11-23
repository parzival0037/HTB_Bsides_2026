SSH="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -i $HOME/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$SSH 'bash -s' <<'REMOTE'
CA=/home/rowan/.local/share/keplerops/ca.crt
for h in $(awk '{print $2}' /etc/hosts | grep -E 'keplerops|arwc' | sort -u); do
 for port in "" ":8443"; do
  u="https://$h$port/.well-known/fieldkest-client"
  r=$(curl -sS -m 6 --cacert $CA "$u" 2>/dev/null)
  if [ -n "$r" ] && ! echo "$r" | grep -q '"error"'; then
    echo "##### $u"; echo "$r" | python3 -c "import sys,json
try:
 d=json.load(sys.stdin); print('TITLE',d.get('title')); print('PURPOSE',d.get('purpose'))
 for rt in d.get('routes',[]): print(' ',rt['key'],rt['method'],rt['template'])
except Exception as e: print('parse',e)"
  fi
 done
done
REMOTE
