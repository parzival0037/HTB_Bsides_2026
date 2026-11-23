P="--socks5-hostname 127.0.0.1:1080 -k -sS --max-time 25"
B=https://cloud-api.keplerops.test
RT=fk_maintenance_runtime_3gIP3j8w6fhkBSqv7J5xllOrDVa2Kzig
WK=fk_ci_maintenance_nU7V3DOnq7kpyAwp46cV50mO8fqtxHSJ
for T in "$RT" "$WK"; do
echo "================ TOKEN ${T:0:24}"
for p in /api/maintenance /api/policies/fieldlink-maintenance /api/schedules/SCHED-2841 /api/exports/EXP-2841 /api/build-records/BLD-1842 /api/trust-records/TRUST-FLX-04; do
 echo "##### $p"; curl $P -H "Authorization: Bearer $T" -i "$B$p" | head -c 1500; echo; done
done
