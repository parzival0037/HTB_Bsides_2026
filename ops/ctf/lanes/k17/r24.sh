set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
CA=/home/rowan/.local/share/keplerops/ca.crt
B=https://support.keplerops.test
J=/tmp/cks.txt; rm -f $J
curl -sS -m 10 --cacert $CA -c $J "$B/scp/login.php" -o /tmp/l.html
T=$(grep -oE 'name="__CSRFToken__" value="[^"]+"' /tmp/l.html | sed -E 's/.*value="([^"]+)".*/\1/')
curl -sS -m 10 --cacert $CA -b $J -c $J -X POST "$B/scp/login.php" \
 --data-urlencode "__CSRFToken__=$T" --data-urlencode "userid=talia.mornac" \
 --data-urlencode "passwd=K17r3v13wTalia2841" --data-urlencode "dst=/scp/tickets.php" \
 --data-urlencode "submit=Sign In" -o /dev/null
txt(){ python3 - <<'PY'
import re,html,sys
d=open('/tmp/pg.html',errors='ignore').read()
d=re.sub(r'<script.*?</script>','',d,flags=re.S); d=re.sub(r'<style.*?</style>','',d,flags=re.S)
t=re.sub(r'<[^>]+>',' ',d); t=html.unescape(t); t=re.sub(r'\s+',' ',t)
print(t[:1800])
PY
}
echo "##### SEARCH Cinder"
curl -sS -m 10 --cacert $CA -b $J -c $J "$B/scp/tickets.php?a=search&keywords=Cinder" -o /tmp/pg.html; txt
echo "##### SEARCH reviewer"
curl -sS -m 10 --cacert $CA -b $J -c $J "$B/scp/tickets.php?a=search&keywords=reviewer" -o /tmp/pg.html; txt
echo "##### KB"
curl -sS -m 10 --cacert $CA -b $J -c $J "$B/scp/kb.php" -o /tmp/pg.html; txt
echo "##### FAQ"
curl -sS -m 10 --cacert $CA -b $J -c $J "$B/scp/faq.php" -o /tmp/pg.html; txt
echo "##### TICKET IDS"
for id in $(seq 1 25); do
 code=$(curl -sS -m 8 --cacert $CA -b $J -c $J -o /tmp/t.html -w '%{http_code}' "$B/scp/tickets.php?id=$id")
 title=$(grep -oE '<title>[^<]*' /tmp/t.html | head -1 | sed 's/<title>//')
 subj=$(grep -oE 'Ticket #<[^>]*>[^<]*' /tmp/t.html | head -1)
 c=$(grep -c 'Ticket #' /tmp/t.html)
 echo "id=$id code=$code title=$title subj=$subj"
done
INNER
