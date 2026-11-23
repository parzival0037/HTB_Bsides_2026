set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
CRED='rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
run(){ echo "===== $1 ====="; $S "$1" 2>&1; echo; }
run 'for U in api/runs/BLD-REC-021 api/runs/BLD-REC-021/log api/build-records/BLD-REC-021 api/builds/BLD-REC-021 api/review-jobs/RJ-E52CFAAD/files api/review-jobs/RJ-E52CFAAD/workspace api/review-jobs/RJ-E52CFAAD/result api/workspaces/WS-ROWAN-2026-09-G1 api/workspaces/WS-ROWAN-2026-09-G1/files; do echo "### GET $U"; curl -sS -m 10 -g --cacert '"$CA"' -u '"$CRED"' -w " [%{http_code}]\n" "https://review.keplerops.test/$U" | head -c 1200; echo; done'
run 'P(){ echo "### $1"; R=$(curl -sS -m 15 -g --cacert '"$CA"' -u '"$CRED"' -X POST -H "Content-Type: application/json" -d "$1" "https://review.keplerops.test/api/review-jobs"); echo "$R"; J=$(echo "$R" | sed -n "s/.*\"run_id\":\"\([^\"]*\)\".*/\1/p"); [ -n "$J" ] && { curl -sS -m 15 -g --cacert '"$CA"' -u '"$CRED"' "https://review.keplerops.test/api/review-jobs/$J" | head -c 1500; echo; }; };
P "{\"support_input\":\"BLD-REC-021\",\"diagnostic\":{\"profile\":\"render-review\"}}"
P "{\"support_input\":\"buildops://builds/BLD-REC-021\",\"diagnostic\":{\"profile\":\"render-review\"}}"
P "{\"support_input\":{\"run_id\":\"BLD-REC-021\"},\"diagnostic\":{\"profile\":\"render-review\"}}"
P "{\"support_input\":{\"record_id\":\"BLD-REC-021\"},\"diagnostic\":{\"profile\":\"render-review\"}}"
P "{\"support_input\":{\"build_record\":\"BLD-REC-021\"},\"diagnostic\":{\"profile\":\"render-review\"}}"
P "{\"support_input\":{\"schema\":\"fieldkest.review-input/v3\",\"run_id\":\"BLD-REC-021\",\"artifact_id\":\"ART-BLD-REC-021\"},\"diagnostic\":{\"profile\":\"render-review\"}}"'
run 'P(){ echo "### profile=$1"; R=$(curl -sS -m 15 -g --cacert '"$CA"' -u '"$CRED"' -X POST -H "Content-Type: application/json" -d "$2" "https://review.keplerops.test/api/review-jobs"); echo "$R"; };
SI='"'"'{"schema":"fieldkest.review-input/v3","artifact_id":"ART-BLD-1842-INTEGRATION-REVIEW","build_revision":"c37effd7cc86ae4d44f18e95f899b7557d65e0a9","classification":"integration-diagnostic","collection":"build-results/BLD-1842","diagnostic_eligible":true,"linked_support_ref":"buildops://reviews/diagnostic-request-reference@3","object_version":3,"run_id":"BLD-1842"}'"'"';
for PR in runner-note build-record build-operations buildops maintainer runner diagnostic inspect handover service-handover; do P "$PR" "{\"support_input\":$SI,\"diagnostic\":{\"profile\":\"$PR\"}}"; done'
