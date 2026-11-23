set +e
ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=8 rowan-dev 'bash -s' <<'RSH'
set +e
I=https://identity.keplerops.test
T="$I/realms/keplerops/protocol/openid-connect/token"
NAMES="workspace workspace-client workspace-cli fieldkest-workspace fieldlink-workspace rowan-workspace workload workload-client fieldlink-workload fieldkest-workload fieldlink-support support support-client support-export support-export-reader export-reader fieldkest-export cloud-api cloud cloud-client data objects fieldkest-client fieldlink-client fieldkest fieldlink rowan rowan.ito maya maya.ranscombe api exchange token-exchange sts keplerops k-dev connector connector-client preview indexer staff tickets assistant review source ci packages cert ca identity admin-cli account account-console security-admin-console broker realm-management fieldkest-cli fieldlink-cli support-client fieldkest-support export export-client exports workload-identity workload-identity-client fieldlink-identity identity-client trust trust-client trust-reader trust-records schedule schedules scheduler maintenance policy policies build-records"
for c in $NAMES; do
 r=$(curl -sSk -m 6 -o /tmp/o -w '%{http_code}' -d "grant_type=urn:ietf:params:oauth:grant-type:token-exchange&client_id=$c" "$T")
 e=$(python3 -c "import json,sys
try:
 d=json.load(open('/tmp/o'));print(d.get('error','')+' | '+str(d.get('error_description','')))
except:print(open('/tmp/o').read()[:80])")
 echo "$c -> $r :: $e"
done
RSH
echo DONE_K14_R22
