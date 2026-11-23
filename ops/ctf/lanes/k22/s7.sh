set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
B=https://support.keplerops.test
cd /tmp; rm -f jar.txt
curl -sS -m 15 --cacert $CA -c jar.txt -b jar.txt "$B/scp/login.php" -o lp.html
CS=$(grep -o 'name="__CSRFToken__" value="[^"]*"' lp.html | head -1 | sed 's/.*value="//;s/"//')
curl -sS -m 15 --cacert $CA -c jar.txt -b jar.txt -L -o /dev/null -w 'login %{http_code}\n' \
  --data-urlencode "__CSRFToken__=$CS" --data-urlencode 'do=scplogin' --data-urlencode 'userid=maya.ranscombe' \
  --data-urlencode 'passwd=sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk' \
  --data-urlencode 'dst=' --data-urlencode 'commit=Log In' "$B/scp/login.php"
for id in 1 2 3 4 5 6; do
  curl -sS -m 15 --cacert $CA -b jar.txt -o tk$id.html "$B/scp/tickets.php?id=$id"
done
python3 - <<'PY'
import re,html,glob
for f in sorted(glob.glob('/tmp/tk*.html')):
    t=open(f,encoding='utf8',errors='replace').read()
    txt=re.sub(r'<script.*?</script>','',t,flags=re.S)
    txt=re.sub(r'<style.*?</style>','',txt,flags=re.S)
    txt=html.unescape(re.sub(r'<[^>]+>',' ',txt))
    txt=re.sub(r'\s+',' ',txt)
    # find the ticket body region: after 'Ticket #' up to 'Post Reply' or 'Thread'
    print('='*30,f)
    m=re.search(r'(Ticket #.{0,120000}?)(?:Post Reply|Post Internal Note|Thread Actions|Add Reply)',txt)
    body=m.group(1) if m else txt[:6000]
    print(body[:7000])
    print('--- links')
    for l in sorted(set(re.findall(r'(?:href|src)="([^"]+)"',t))):
        if any(k in l for k in ('file','attach','view.php','download')): print(' ',l)
PY
INNER
