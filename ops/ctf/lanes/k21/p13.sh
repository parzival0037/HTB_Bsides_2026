set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
A=https://assistant.keplerops.test
B=https://staff.keplerops.test
I=https://identity.keplerops.test/realms/keplerops/protocol/openid-connect/token
DEV='rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'
echo "######## indexer basic dev"
curl -sSk -m 10 --cacert $CA -u "$DEV" -i "https://indexer.keplerops.test/api/config" | head -20
echo "######## managed-identities full headers"
curl -sSk -m 10 --cacert $CA -u "$DEV" -i -X POST -H 'Content-Type: application/json' -d '{}' "$B/api/managed-identities/support/session" | head -25
echo "######## Keycloak password grant attempts"
for cid in account admin-cli OIDC-FIELDKEST-SUPPORT fieldkest-support keplerops-support support assistant staff; do
  for pw in 'fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo' 'fieldlink-dev-2841'; do
    r=$(curl -sSk -m 10 --cacert $CA -X POST -d "client_id=$cid" -d "grant_type=password" -d "username=rowan.ito" --data-urlencode "password=$pw" -w '|%{http_code}' "$I")
    echo "cid=$cid pw=${pw:0:12} -> $(echo "$r" | tail -c 400)"
  done
done
echo "######## Keycloak maya attempt"
for cid in account OIDC-FIELDKEST-SUPPORT fieldkest-support support; do
  r=$(curl -sSk -m 10 --cacert $CA -X POST -d "client_id=$cid" -d "grant_type=password" -d "username=maya.ranscombe" --data-urlencode "password=sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk" -w '|%{http_code}' "$I")
  echo "cid=$cid -> $(echo "$r" | tail -c 400)"
done
INNER
echo DONE_MARK_$RANDOM
