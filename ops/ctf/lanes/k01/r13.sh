set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'RSH'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
U='rowan.ito'; P='fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'
rm -f /tmp/kb
csrf=$(curl -sS -m 10 --cacert $CA -c /tmp/kb 'https://staff.keplerops.test/login' | grep -oP 'name="csrf_token" value="\K[^"]+')
curl -sS -m 10 -o /dev/null --cacert $CA -b /tmp/kb -c /tmp/kb --data-urlencode "csrf_token=$csrf" --data-urlencode "username=$U" --data-urlencode "password=$P" 'https://staff.keplerops.test/login/check'
echo "---FILE---"
curl -sS -m 10 --cacert $CA -b /tmp/kb 'https://staff.keplerops.test/?controller=TaskFileController&action=download&task_id=1&file_id=1'; echo
echo "===HELPER TEST==="
cd /home/rowan/work
curl -sS -m 20 -i --form sample=@samples/FK-SAMPLE-017.json http://127.0.0.1:8701/api/inspection-summary | head -40
echo; echo "===HELPER OPTIONS==="
curl -sS -m 10 -i -X OPTIONS http://127.0.0.1:8701/api/inspection-summary | head -15
RSH
