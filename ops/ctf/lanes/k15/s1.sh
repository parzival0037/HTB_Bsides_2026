set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'RSH'
set +e
CA=$HOME/.local/share/keplerops/ca.crt
JWT=$(kubectl config view --raw -o jsonpath='{.users[0].user.token}')
C=https://cloud-api.keplerops.test
B="Authorization: Bearer $JWT"
echo "###### JWT claims"
python3 - "$JWT" <<'PY'
import sys,base64,json
t=sys.argv[1].split('.')[1]; t+='='*(-len(t)%4)
print(json.dumps(json.loads(base64.urlsafe_b64decode(t)),indent=1))
PY
echo "###### cloud-api root/wellknown/openapi"
for p in "" ".well-known/fieldkest-client" "openapi.json" "api" "api/exports" "api/exports/" "api/export-jobs" "api/jobs"; do
  echo "--- [$p]"
  curl -sS -m 10 --cacert $CA -H "$B" -w '\n[%{http_code}]\n' "$C/$p" | head -c 1200; echo
done
echo "###### sweep endpoints"
for p in api/exports/EXP-2841 api/exports/EXP-2841/definition api/exports/EXP-2841/revisions api/exports/EXP-2841/handover api/exports/EXP-2841/jobs api/export-jobs/EXP-2841 api/jobs api/jobs/EXP-2841 api/maintenance api/workspaces/current api/trust-records/TR-1 api/handovers api/handovers/current api/schedules/SCHED-2841; do
  echo "--- GET $p"
  curl -sS -m 10 --cacert $CA -H "$B" -w '\n[%{http_code}]\n' "$C/$p" | head -c 900; echo
done
echo "###### support integration"
SU=https://support.keplerops.test:8443
BK="Authorization: Bearer fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b"
for p in "" ".well-known/fieldkest-client" api/customers api/customers/TEN-ARWC-047 api/customers/TEN-ARWC-047/diagnostics api/customers/TEN-ARWC-047/exports api/diagnostics/DIAG-ARWC-0214CB78 api/handovers api/handovers/current api/jobs api/exports api/export-jobs; do
  echo "--- GET $p"
  curl -sS -m 12 --cacert $CA -H "$BK" -w '\n[%{http_code}]\n' "$SU/$p" | head -c 1200; echo
done
RSH
echo DONE_S1
