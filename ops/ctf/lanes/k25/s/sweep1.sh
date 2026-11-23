CA=$HOME/k25/ca.crt; P="--socks5-hostname 127.0.0.1:1080"
hosts="support.keplerops.test staff.keplerops.test workboard.keplerops.test assistant.keplerops.test connector.arwc.test api.keplerops.test integration.keplerops.test integrations.keplerops.test tenants.keplerops.test tenant.keplerops.test customers.keplerops.test crm.keplerops.test dossier.keplerops.test dossiers.keplerops.test records.keplerops.test archive.keplerops.test support-tools.keplerops.test tickets.keplerops.test data.keplerops.test identity.keplerops.test cert.keplerops.test ca.keplerops.test objects.keplerops.test cloud-api.keplerops.test review.keplerops.test preview.keplerops.test indexer.keplerops.test source.keplerops.test packages.keplerops.test ci.keplerops.test workloads.keplerops.test portal.arwc.test docs.arwc.test connector.arwc.test delivery.keplerops.test"
for h in $hosts; do
  for port in "" ":8443" ":8080"; do
    out=$(curl -sS $P --cacert $CA -m 8 -w '\n%{http_code}' "https://$h$port/.well-known/fieldkest-client" 2>/dev/null)
    code=$(echo "$out" | tail -1)
    body=$(echo "$out" | sed '$d')
    if [ "$code" = "200" ]; then
      echo "===== https://$h$port"
      echo "$body"
    fi
  done
done
