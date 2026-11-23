set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
cd /tmp; rm -f jar.txt
B=https://support.keplerops.test
echo "===== osticket login ====="
curl -sS -m 15 --cacert $CA -c jar.txt -b jar.txt "$B/scp/login.php" -o lp.html -w 'loginpage %{http_code}\n'
CS=$(grep -o 'name="__CSRFToken__" value="[^"]*"' lp.html | head -1 | sed 's/.*value="//;s/"//')
echo "csrf=$CS"
curl -sS -m 15 --cacert $CA -c jar.txt -b jar.txt -L -o lo.html -w 'loginpost %{http_code} %{url_effective}\n' \
  --data-urlencode "__CSRFToken__=$CS" --data-urlencode 'do=scplogin' --data-urlencode 'userid=maya.ranscombe' \
  --data-urlencode 'passwd=sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk' \
  --data-urlencode 'dst=' --data-urlencode 'commit=Log In' "$B/scp/login.php"
grep -o '<title>[^<]*' lo.html | head -3
echo "--- cookies"; cat jar.txt
echo "===== ticket list ====="
curl -sS -m 15 --cacert $CA -c jar.txt -b jar.txt -o tl.html -w 'tickets %{http_code} %{url_effective}\n' "$B/scp/tickets.php"
grep -oE 'tickets\.php[^"]*' tl.html | sort -u | head -40
grep -oiE '(SUP|REV)-[0-9]+' tl.html | sort -u | head
echo "===== ticket 2841 ====="
curl -sS -m 15 --cacert $CA -c jar.txt -b jar.txt -o t2841.html -w 't2841 %{http_code} %{size_download}\n' "$B/scp/tickets.php?id=2841"
python3 - <<'PY'
import re,html
try: t=open('/tmp/t2841.html',encoding='utf8',errors='replace').read()
except Exception as e: print(e); raise SystemExit
txt=re.sub(r'<script.*?</script>','',t,flags=re.S)
txt=re.sub(r'<style.*?</style>','',txt,flags=re.S)
txt=re.sub(r'<[^>]+>',' ',txt)
txt=html.unescape(txt)
print(re.sub(r'\s+',' ',txt)[:4000])
print('--- links')
for m in sorted(set(re.findall(r'(?:href|src)="([^"]+)"',t))):
    if 'view.php' in m or 'file' in m.lower() or 'attach' in m.lower(): print(m)
PY
echo "===== assistant login ====="
curl -sS -m 15 --cacert $CA -X POST -H 'Content-Type: application/json' \
  -d '{"username":"maya.ranscombe","password":"sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk"}' \
  -o at.json -w 'reqtoken %{http_code}\n' https://assistant.keplerops.test/api/request-token
head -c 500 at.json; echo
TK=$(python3 -c "import json;d=json.load(open('/tmp/at.json'));print(d.get('token') or '')" 2>/dev/null)
echo "token len ${#TK}"
if [ -n "$TK" ]; then
  curl -sS -m 15 --cacert $CA -H "Authorization: Bearer $TK" -o ws.json -w 'workspaces %{http_code}\n' https://assistant.keplerops.test/api/workspaces
  head -c 2000 ws.json; echo
fi
INNER
