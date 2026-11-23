set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
CRED='rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
run(){ echo "===== $1 ====="; $S "$1" 2>&1; echo; }
run 'for J in RJ-98A488EE RJ-A8201F38 RJ-0E82CC86 RJ-5503AF83 RJ-49A48957 RJ-47646780 RJ-880648C0 RJ-D7A511C7 RJ-C54C201C RJ-880097BD RJ-C20C111A; do echo "### $J"; curl -sS -m 10 -g --cacert '"$CA"' -u '"$CRED"' "https://review.keplerops.test/api/review-jobs/$J" | head -c 900; echo; done'
run 'P(){ echo "### profile=$1"; R=$(curl -sS -m 15 -g --cacert '"$CA"' -u '"$CRED"' -X POST -H "Content-Type: application/json" -d "$2" "https://review.keplerops.test/api/review-jobs"); echo "$R"; J=$(echo "$R" | sed -n "s/.*\"run_id\":\"\([^\"]*\)\".*/\1/p"); [ -n "$J" ] && { curl -sS -m 15 -g --cacert '"$CA"' -u '"$CRED"' "https://review.keplerops.test/api/review-jobs/$J" | head -c 900; echo; }; };
SI='"'"'{"schema":"fieldkest.review-input/v3","artifact_id":"ART-BLD-1842-INTEGRATION-REVIEW","build_revision":"c37effd7cc86ae4d44f18e95f899b7557d65e0a9","classification":"integration-diagnostic","collection":"build-results/BLD-1842","diagnostic_eligible":true,"linked_support_ref":"buildops://reviews/diagnostic-request-reference@3","object_version":3,"run_id":"BLD-1842"}'"'"';
for PR in runner-command Runner-Command runner_command runner-command2 "runner-command " shell exec command runner-exec; do P "$PR" "{\"support_input\":$SI,\"diagnostic\":{\"profile\":\"$PR\",\"argv\":[\"/bin/pwd\"]}}"; done'
