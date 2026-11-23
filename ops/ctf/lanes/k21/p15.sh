set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
A=https://assistant.keplerops.test
B=https://staff.keplerops.test
ID=https://identity.keplerops.test
TOK=$ID/realms/keplerops/protocol/openid-connect/token
export KRB5CCNAME=/tmp/krb5cc_k21
echo "######## keycloak token decode"
RESP=$(curl -sSk -m 10 --cacert $CA -X POST -d 'client_id=admin-cli' -d 'grant_type=password' -d 'username=rowan.ito' --data-urlencode 'password=fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo' "$TOK")
echo "$RESP" | head -c 400; echo
KT=$(echo "$RESP" | python3 -c 'import json,sys;print(json.load(sys.stdin).get("access_token",""))')
python3 - "$KT" <<'PY'
import sys,base64,json
t=sys.argv[1].split('.')[1]
t+='='*(-len(t)%4)
print(json.dumps(json.loads(base64.urlsafe_b64decode(t)),indent=1)[:3000])
PY
echo "######## userinfo"
curl -sSk -m 10 --cacert $CA -H "Authorization: Bearer $KT" -w '\n[%{http_code}]\n' "$ID/realms/keplerops/protocol/openid-connect/userinfo" | head -c 800
echo "######## admin REST clients"
curl -sSk -m 10 --cacert $CA -H "Authorization: Bearer $KT" -w '\n[%{http_code}]\n' "$ID/admin/realms/keplerops/clients?clientId=OIDC-FIELDKEST-SUPPORT" | head -c 1200
echo; curl -sSk -m 10 --cacert $CA -H "Authorization: Bearer $KT" -w '\n[%{http_code}]\n' "$ID/admin/realms/keplerops/users?username=rowan.ito" | head -c 1200
echo "######## token exchange"
for aud in OIDC-FIELDKEST-SUPPORT fieldkest-support account; do
  echo "--- aud=$aud"
  curl -sSk -m 10 --cacert $CA -X POST -d 'client_id=admin-cli' -d 'grant_type=urn:ietf:params:oauth:grant-type:token-exchange' -d 'subject_token_type=urn:ietf:params:oauth:token-type:access_token' --data-urlencode "subject_token=$KT" -d 'requested_token_type=urn:ietf:params:oauth:token-type:access_token' -d "audience=$aud" -w '\n[%{http_code}]\n' "$TOK" | head -c 800
done
echo "######## grep rowan files for OIDC/registration/secret"
grep -rin --exclude-dir=.config --exclude-dir=.cache 'OIDC\|client_secret\|registration\|FEDERATION' /home/rowan 2>/dev/null | head -20
echo "######## kerberos managed identities list"
echo 'fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo' | kinit rowan.ito 2>/dev/null
for sid in assistant assistant.keplerops.test fieldkest-assistant support-assistant support-private support fieldkest-support OIDC-FIELDKEST-SUPPORT workspace fieldlink-workspace objects cloud-api data; do
  echo "--- $sid"
  curl -sSk -m 8 --cacert $CA --negotiate -u : -X POST -H 'Content-Type: application/json' -d '{}' -w '\n[%{http_code}]\n' "$B/api/managed-identities/$sid/session" | head -c 400
done
kdestroy 2>/dev/null
INNER
echo DONE_MARK_$RANDOM
