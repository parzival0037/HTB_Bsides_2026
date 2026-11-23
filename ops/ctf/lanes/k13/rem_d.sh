set +e
TOK='FLAG{6bb66074f2325405}'
CA=/home/rowan/.local/share/keplerops/ca.crt
for h in workload workloads cloud-api objects identity workloads.keplerops.test; do
  echo "########## $h https://$h.keplerops.test/"
  curl -sSk -m 8 -i "https://$h.keplerops.test/" 2>&1 | head -25
done
echo "########## workload paths"
for p in health version api api/v1 api/v1/records api/records .well-known/fieldkest-client openapi.json docs; do
  echo "--- /$p"
  curl -sSk -m 8 -i "https://workload.keplerops.test/$p" 2>&1 | head -20
done
echo "########## with token"
for h in workload workloads cloud-api; do
  echo "--- $h auth"
  curl -sSk -m 8 -i -H "Authorization: Bearer $TOK" "https://$h.keplerops.test/" 2>&1 | head -20
done
echo "########## S3 with token as key id"
curl -sSk -m 8 -i -H "Authorization: Bearer $TOK" "https://objects.keplerops.test/fieldkest-workspaces?list-type=2" | head -20
