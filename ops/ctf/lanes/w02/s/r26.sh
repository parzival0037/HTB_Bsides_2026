P="--socks5-hostname 127.0.0.1:1080 -k -sS --max-time 20"
RT=fk_maintenance_runtime_3gIP3j8w6fhkBSqv7J5xllOrDVa2Kzig
WK=fk_ci_maintenance_nU7V3DOnq7kpyAwp46cV50mO8fqtxHSJ
B=https://connector.arwc.test
for T in "$RT" "$WK"; do
echo "================ TOKEN ${T:0:26}"
for path in /api/fieldlink/diagnostics /api/fieldlink/packages/poll; do
 echo "##### GET $path"; curl $P -H "Authorization: Bearer $T" -H 'X-Workload-Class: maintenance' -H 'X-Scheduler-Attestation: fieldkest-scheduler' -i "$B$path" | head -c 1200; echo
done
echo "##### POST poll"; curl $P -H "Authorization: Bearer $T" -H 'X-Workload-Class: maintenance' -H 'X-Scheduler-Attestation: fieldkest-scheduler' -X POST -H 'Content-Type: application/json' -d '{}' -i "$B/api/fieldlink/packages/poll" | head -c 1500; echo
echo "##### POST diagnostics"; curl $P -H "Authorization: Bearer $T" -H 'X-Workload-Class: maintenance' -H 'X-Scheduler-Attestation: fieldkest-scheduler' -X POST -H 'Content-Type: application/json' -d '{"archive":"FIELD-CRR-2026-09"}' -i "$B/api/fieldlink/diagnostics" | head -c 1500; echo
done
echo "### unauth diagnostics GET"; curl $P -i "$B/api/fieldlink/diagnostics" | head -c 600; echo
