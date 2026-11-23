#!/bin/bash
set +e
ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=10 rowan-dev 'bash -s' <<'RSH'
set +e
CA=$HOME/.local/share/keplerops/ca.crt
echo "###### HOME CONFIG/LOCAL"
ls -la ~/.config ~/.local/share/keplerops ~/.config/fieldlink 2>&1
echo "###### support-client.json"
cat ~/.config/fieldlink/support-client.json 2>&1
echo "###### keplerops dir files"
for f in ~/.local/share/keplerops/*; do echo "--- $f"; file "$f"; head -c 400 "$f" 2>/dev/null; echo; done
echo "###### kerberos config + keytabs"
cat /etc/krb5.conf 2>&1 | head -60
ls -la ~/*.keytab ~/.config/*.keytab /etc/*.keytab 2>&1
klist 2>&1 | head -20
which kinit klist kvno 2>&1
echo "###### identity realm"
for u in "https://identity.keplerops.test/realms/keplerops/.well-known/openid-configuration" "https://identity.keplerops.test/realms/keplerops" "https://identity.keplerops.test/realms/keplerops/protocol/openid-connect/token" "https://id.keplerops.test/realms/keplerops/.well-known/openid-configuration"; do
  echo "--- $u"; curl -sS -m 10 --cacert $CA -o /tmp/id -w '[%{http_code}]\n' "$u"; head -c 800 /tmp/id; echo
done
echo "###### chromium history"
DB=~/.config/chromium/Default
ls -la $DB 2>&1 | head -20
cp "$DB/History" /tmp/h.db 2>/dev/null && sqlite3 /tmp/h.db "select url,title from urls order by last_visit_time desc limit 40;" 2>&1 | head -50
RSH
echo DONE_R4
