set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
A=https://assistant.keplerops.test
B=https://staff.keplerops.test
export KRB5CCNAME=/tmp/krb5cc_k21
export KRB5_CONFIG=/etc/krb5.conf
echo "######## keytabs"
sudo -n klist -k /etc/krb5.keytab 2>&1 | head -20
find /home/rowan -name '*.keytab' 2>/dev/null | head
cat /etc/krb5.conf 2>/dev/null | head -40
echo "######## kinit attempts"
for spec in "rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo" "rowan.ito:fieldlink-dev-2841" "maya.ranscombe:sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk"; do
  u=${spec%%:*}; p=${spec#*:}
  echo "--- kinit $u"
  echo "$p" | kinit "$u" 2>&1 | head -5
  klist 2>&1 | head -6
  kdestroy 2>/dev/null
done
echo "######## if kinit rowan works, negotiate"
echo 'fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo' | kinit rowan.ito 2>&1 | head -3
klist 2>&1 | head -6
echo "--- staff negotiate service-directory"
curl -sSk -m 10 --cacert $CA --negotiate -u : -i "$B/api/service-directory" | head -30
echo "--- staff negotiate managed session support"
curl -sSk -m 10 --cacert $CA --negotiate -u : -i -X POST -H 'Content-Type: application/json' -d '{}' "$B/api/managed-identities/support/session" | head -30
echo "--- assistant negotiate conversations"
curl -sSk -m 10 --cacert $CA --negotiate -u : -i "$A/api/conversations/CONV-SUP-2841-19" | head -30
echo "######## Keycloak token then try endpoints"
I=https://identity.keplerops.test/realms/keplerops/protocol/openid-connect/token
KT=$(curl -sSk -m 10 --cacert $CA -X POST -d 'client_id=admin-cli' -d 'grant_type=password' -d 'username=rowan.ito' --data-urlencode 'password=fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo' "$I" | python3 -c 'import json,sys;d=json.load(sys.stdin);print(d.get("access_token",""))')
echo "KT len ${#KT}"
[ -n "$KT" ] && curl -sSk -m 10 --cacert $CA -H "Authorization: Bearer $KT" "https://identity.keplerops.test/realms/keplerops/protocol/openid-connect/userinfo" | head -c 500
echo
echo "--- assistant with keycloak token"
curl -sSk -m 10 --cacert $CA -H "Authorization: Bearer $KT" -w '\n[%{http_code}]\n' "$A/api/conversations/CONV-SUP-2841-19" | head -c 800
echo "--- assistant answers with keycloak token"
curl -sSk -m 15 --cacert $CA -H "Authorization: Bearer $KT" -H 'Content-Type: application/json' -d '{"request":"private_escalation","context_id":"ctx-support-private-v4","conversation_id":"CONV-SUP-2841-19"}' -w '\n[%{http_code}]\n' "$A/api/answers" | head -c 800
echo "--- staff directory with keycloak token"
curl -sSk -m 10 --cacert $CA -H "Authorization: Bearer $KT" -w '\n[%{http_code}]\n' "$B/api/service-directory" | head -c 500
kdestroy 2>/dev/null
INNER
echo DONE_MARK_$RANDOM
