set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
T="fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b"
echo "===== review worker well-known ====="
curl -sS -m 10 --cacert $CA -o /tmp/rw.json -w '%{http_code} %{content_type}\n' https://review.keplerops.test/.well-known/fieldkest-client
head -c 2500 /tmp/rw.json; echo
echo "===== review worker root/jobs ====="
for p in / /api/jobs /api/reviews /api/reviews/REV-2841 /health; do echo "## $p"; curl -sS -m 10 --cacert $CA -H "Authorization: Bearer $T" -o /tmp/x.out -w '%{http_code} %{content_type} %{size_download}\n' "https://review.keplerops.test$p"; head -c 500 /tmp/x.out; echo; done
echo "===== staff workboard follow redirect ====="
rm -f sj.txt
curl -sS -m 15 --cacert $CA -c sj.txt -b sj.txt -L -o /tmp/sb.html -w 'board %{http_code} %{url_effective} %{size_download}\n' https://staff.keplerops.test/
grep -oE '<title>[^<]*' /tmp/sb.html | head -2
python3 - <<'PY'
import re,html
t=open('/tmp/sb.html',encoding='utf8',errors='replace').read()
txt=re.sub(r'<script.*?</script>','',t,flags=re.S); txt=re.sub(r'<style.*?</style>','',txt,flags=re.S)
txt=html.unescape(re.sub(r'<[^>]+>',' ',txt)); print(re.sub(r'\s+',' ',txt)[:2500])
print('--- links'); 
for l in sorted(set(re.findall(r'(?:href|action)="([^"]+)"',t)))[:40]: print(l)
PY
echo "===== support :8443 more routes ====="
for p in /api/reviews/REV-2841/accept /api/diagnostic-reviews /api/reviews/REV-2841/decision /api/reviews/REV-2841/approve; do echo "## $p"; curl -sS -m 10 --cacert $CA -H "Authorization: Bearer $T" -o /tmp/x.out -w '%{http_code} %{content_type}\n' "https://support.keplerops.test:8443$p"; head -c 300 /tmp/x.out; echo; done
INNER
