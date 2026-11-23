set +e
for h in support staff workboard identity ca cert tickets assistant llm packages delivery review indexer preview ci source source-tools objects cloud-api workloads workload data; do
  echo "##### $h"
  curl -sSk -m 6 "https://$h.keplerops.test/.well-known/fieldkest-client" | head -c 2500; echo
done
