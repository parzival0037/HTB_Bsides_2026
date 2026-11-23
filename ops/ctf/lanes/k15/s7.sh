set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'RSH'
set +e
CA=$HOME/.local/share/keplerops/ca.crt
U=https://support.keplerops.test
rm -f /tmp/cj
echo "###### login page"
curl -sS -m 15 -c /tmp/cj "$U/scp/login.php" --cacert "$CA" -o /tmp/lp.html -w 'code=%{http_code}\n'
python3 - <<'PY'
import re
s=open('/tmp/lp.html',errors='replace').read()
m=re.search(r'<form[^>]*login[^>]*>.*?</form>',s,re.S|re.I)
print(re.sub(r'\s+',' ',m.group(0))[:2000] if m else 'no form')
for n in re.findall(r'name="([^"]+)"',s): print('field',n)
PY
echo "###### POST login"
curl -sS -m 20 -b /tmp/cj -c /tmp/cj -i -X POST "$U/scp/login.php" --cacert "$CA" \
 --data-urlencode "userid=maya.ranscombe" --data-urlencode "passwd=sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk" \
 --data "do=scplogin" --data "submit=Log+In" -o /tmp/lr.txt
head -25 /tmp/lr.txt
echo "###### index after login"
curl -sS -m 15 -b /tmp/cj -L "$U/scp/index.php" --cacert "$CA" -o /tmp/idx.html -w 'code=%{http_code}\n'
grep -ioE "invalid login|welcome|dashboard|log out|tickets\.php\?id=[0-9]+" /tmp/idx.html | sort -u | head
echo "###### tickets list"
curl -sS -m 15 -b /tmp/cj "$U/scp/tickets.php" --cacert "$CA" -o /tmp/t.html -w 'code=%{http_code}\n'
python3 - <<'PY'
import re,html
s=open('/tmp/t.html',errors='replace').read()
print('len',len(s))
ids=sorted(set(re.findall(r'tickets\.php\?id=(\d+)',s)))
print('ids',ids[:40])
for m in re.finditer(r'href="tickets\.php\?id=(\d+)"[^>]*>(.*?)</a>',s,re.S):
    print(m.group(1), html.unescape(re.sub('<[^>]+>','',m.group(2))).strip()[:80])
PY
for i in $(seq 1 8); do
  curl -sS -m 12 -b /tmp/cj "$U/scp/tickets.php?id=$i" --cacert "$CA" -o /tmp/tk$i.html -w "ticket $i code=%{http_code}\n"
done
python3 - <<'PY'
import re,html,glob
for f in sorted(glob.glob('/tmp/tk*.html')):
    s=open(f,errors='replace').read()
    title=re.search(r'<title>(.*?)</title>',s,re.S)
    subj=re.search(r'<h1[^>]*>(.*?)</h1>',s,re.S)
    body=re.sub(r'<script.*?</script>','',s,flags=re.S)
    body=re.sub(r'<style.*?</style>','',body,flags=re.S)
    txt=html.unescape(re.sub(r'<[^>]+>',' ',body))
    txt=re.sub(r'\s+',' ',txt)
    print('=====',f, title.group(1).strip() if title else '', '|', re.sub('<[^>]+>','',subj.group(1)).strip() if subj else '')
    # find lines with key terms
    for kw in ['SUP-2841','ESC-2841','REV-2841','export','EXP-2841','JOB-','revision','dataset','partition','handover','FLAG{']:
        for m in re.finditer(kw, txt, re.I):
            a=max(0,m.start()-120); b=min(len(txt),m.end()+180)
            print('  ['+kw+']', txt[a:b])
            break
PY
echo "###### gitea issue bodies"
A="Authorization: Basic $(printf "rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo" | base64 -w0)"
G=https://source.keplerops.test/api/v1/repos/fieldkest/fieldlink-connector
for n in 1 2 3 4; do
  echo "--- issue $n"
  curl -sS -m 12 --cacert $CA -H "$A" "$G/issues/$n" | python3 -c "import json,sys;d=json.load(sys.stdin);print(d.get(\"title\"));print(d.get(\"body\"))" 2>&1 | head -40
done
echo "###### well-known across hosts"
JWT=$(kubectl config view --raw -o jsonpath='{.users[0].user.token}')
for h in cloud-api workloads workload data tickets id staff workboard objects cert; do
  echo "=== $h"
  curl -sS -m 8 --cacert $CA -H "Authorization: Bearer $JWT" "https://$h.keplerops.test/.well-known/fieldkest-client" | head -c 700; echo
done
RSH
echo DONE_S7
