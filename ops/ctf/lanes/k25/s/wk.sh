CA=$HOME/k25/ca.crt; P="--socks5-hostname 127.0.0.1:1080"
for h in source.keplerops.test source-tools.keplerops.test packages.keplerops.test ci.keplerops.test review.keplerops.test preview.keplerops.test indexer.keplerops.test assistant.keplerops.test llm.keplerops.test staff.keplerops.test workboard.keplerops.test identity.keplerops.test id.keplerops.test data.keplerops.test objects.keplerops.test cloud-api.keplerops.test workloads.keplerops.test cert.keplerops.test ca.keplerops.test tickets.keplerops.test connector.arwc.test delivery.keplerops.test; do
  echo "########## $h"
  for port in "" ":8443"; do
    out=$(curl -sS $P --cacert $CA -m 12 -w '\n%{http_code}' "https://$h$port/.well-known/fieldkest-client" 2>&1)
    code=$(echo "$out" | tail -1)
    body=$(echo "$out" | head -n -1)
    if [ "$code" = "200" ]; then echo "  [$port] $body"; fi
  done
done
