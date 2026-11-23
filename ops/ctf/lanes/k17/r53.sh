set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
echo "===== grep cinder/alternate in rowan home (small files) ====="
grep -rniI --exclude-dir=.cache --exclude-dir=.npm --exclude-dir=.mozilla --exclude-dir=node_modules -e 'cinder' -e 'alternate reviewer' -e 'case note' /home/rowan 2>/dev/null | cut -c1-300 | head -40
echo "===== authorized_keys ====="
cat /home/rowan/.ssh/authorized_keys 2>/dev/null | head -5
echo "===== review-exports search ====="
find / -xdev -iname '*review-export*' -o -xdev -iname 'fieldlink-7.4.2-review*' 2>/dev/null | head -20
echo "===== files with 'REV-231' or 'unresolved' ====="
grep -rlnI 'REV-231\|unresolved provider-report' /home /tmp /var/tmp /srv /opt 2>/dev/null | head -20
echo "===== /etc/hosts full ====="
cat /etc/hosts
echo "===== staff api fuzz ====="
CA=/home/rowan/.local/share/keplerops/ca.crt
E=/home/rowan/work/certificates/evan.calderoux
for p in /openapi.json /api/docs /api/routes /routes /metrics /health /api/health /api/version /version /api/archive/handovers /api/archive/handover /api/archive/delegation /api/archive/delegations /api/archive/delegation/route /api/archive/delegation/request /api/archive/delegations/probe /api/delegation /api/delegations /api/archive/cases /api/cases /api/case /api/case-notes /api/notes /api/enrollment /api/managed-identities /api/directory /api/archive/notes /api/archive/records /api/records /api/handovers; do
  code=$(curl -sSk -m 6 --cacert $CA --cert $E.crt --key $E.key -o /tmp/fz.out -w '%{http_code}' "https://staff.keplerops.test$p")
  [ "$code" != "404" ] && { echo "=== $p [$code]"; head -c 400 /tmp/fz.out; echo; }
done
echo "===== kanboard project ids as rowan ====="
J=/tmp/kbj.txt; rm -f $J
curl -sSk -m 8 --cacert $CA -c $J "https://staff.keplerops.test/login" -o /tmp/lg.html
C=$(grep -oE 'name="csrf_token" value="[^"]+"' /tmp/lg.html | sed -E 's/.*value="([^"]+)".*/\1/')
curl -sSk -m 8 --cacert $CA -b $J -c $J -X POST "https://staff.keplerops.test/login/check" --data-urlencode "csrf_token=$C" --data-urlencode "username=rowan.ito" --data-urlencode "password=fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo" --data-urlencode "remember_me=1" -o /dev/null
for id in 2 3 4 5 6; do
 echo -n "project/$id: "; curl -sSk -m 6 --cacert $CA -b $J -o /tmp/pj.html -w '%{http_code} ' "https://staff.keplerops.test/project/$id"; grep -oE '<title>[^<]*' /tmp/pj.html | head -1
 echo -n "board/$id: "; curl -sSk -m 6 --cacert $CA -b $J -o /tmp/pj.html -w '%{http_code} ' "https://staff.keplerops.test/board/$id"; grep -oE '<title>[^<]*' /tmp/pj.html | head -1
done
for t in 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20; do
 code=$(curl -sSk -m 6 --cacert $CA -b $J -o /tmp/tk.html -w '%{http_code}' "https://staff.keplerops.test/task/$t")
 title=$(grep -oE '<title>[^<]*' /tmp/tk.html | head -1 | sed 's/ <title>//')
 echo "task/$t [$code] $title"
done
INNER
echo DONE_R53
