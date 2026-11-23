set +e
ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=8 rowan-dev 'bash -s' <<'RSH'
set +e
S=https://staff.keplerops.test
U='rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'
M='maya.ranscombe:sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk'
echo "=== DIRECTORY rowan ==="
curl -sSk -m 8 -u "$U" "$S/api/service-directory" | tee /tmp/dir.json | head -c 6000; echo
echo "=== DIRECTORY maya ==="
curl -sSk -m 8 -u "$M" "$S/api/service-directory" | head -c 3000; echo
echo "=== NOTES ==="
for n in NOTE-SUP-2841-7 SUP-2841 workspace workload trust TR-1; do
 echo "-- $n"; curl -sSk -m 6 -u "$U" -w '\n[%{http_code}]\n' "$S/api/notes/$n" | head -c 500
done
echo "=== ARCHIVE ==="
for sub in workspace workload handovers support fieldlink trust; do
 echo "-- $sub"; curl -sSk -m 6 -u "$U" -w '\n[%{http_code}]\n' "$S/api/archive/handovers/$sub" | head -c 500
done
echo "=== MANAGED IDS (probe) ==="
for sid in workload workloads workspace cloud-api objects support fieldlink rowan-workspace fieldlink-workload support-export; do
 echo "-- $sid"; curl -sSk -m 6 -u "$U" -X POST -H 'Content-Type: application/json' -d '{}' -w '\n[%{http_code}]\n' "$S/api/managed-identities/$sid/session" | head -c 600
done
echo "=== STAFF ROOT/UNKNOWN ==="
for p in "" api api/trust api/workloads api/managed-identities .well-known/fieldkest-client api/enrollment/keplerops-staff; do
 echo "-- /$p"; curl -sSk -m 6 -u "$U" -w '\n[%{http_code}]\n' "$S/$p" | head -c 500
done
echo "=== /opt workbench ==="
ls -la /opt/fieldkest-workbench/ 2>&1 | head
cat /opt/fieldkest-workbench/workbench.py 2>/dev/null | head -c 3000
RSH
echo DONE_K14_R7
