set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
A=https://assistant.keplerops.test
echo "########## SETUP-COMPLETE FULL"
curl -sS -m 10 --cacert $CA "$A/api/setup-complete" 2>&1
echo
echo "########## FS GREP assistant/anythingllm"
grep -ril --exclude-dir=.cache --exclude-dir=node_modules --exclude-dir=.git 'anythingllm\|assistant\.keplerops\|assistant' /home/rowan /etc /srv /opt 2>/dev/null | head -40
echo "########## work dirs"
find /home/rowan -maxdepth 3 -name '*.md' -o -maxdepth 3 -name '*.json' -o -maxdepth 3 -name '*.yml' 2>/dev/null | grep -v node_modules | head -60
echo "########## support desk login test"
curl -sS -m 10 --cacert $CA -o /tmp/sup_login.html -w '%{http_code}\n' -c /tmp/supjar -d 'userid=maya.ranscombe&passwd=sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk&do=sign-in' https://support.keplerops.test/scp/login.php 2>&1
grep -o 'Location: .*' /tmp/sup_login.html | head
curl -sS -m 10 --cacert $CA -b /tmp/supjar -o /tmp/sup_tix.html -w 'tickets:%{http_code}\n' 'https://support.keplerops.test/scp/tickets.php' 2>&1
grep -oE 'tickets\.php\?id=[0-9]+[^"]*' /tmp/sup_tix.html | sort -u | head -20
grep -oE '<td[^>]*>[^<]{3,80}</td>' /tmp/sup_tix.html | head -40
echo "########## support api with bearer"
for p in /api/tickets /api/tickets/SUP-2841 /api/cases /api/support/cases /api/v1/tickets; do
 echo "--- $p"; curl -sS -m 6 --cacert $CA -i -H "Authorization: Bearer fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b" "https://support.keplerops.test$p" 2>&1 | head -8
done
INNER
echo DONE_MARK_$RANDOM
