set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
CRED='rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
run(){ echo "===== $1 ====="; $S "$1" 2>&1; echo; }
run "P(){ echo \"### \$1\"; R=\$(curl -sS -m 10 -g --cacert $CA -u '$CRED' -X POST -H 'Content-Type: application/json' -d \"\$1\" 'https://review.keplerops.test/api/review-jobs'); echo \"\$R\"; J=\$(echo \"\$R\" | sed -n 's/.*\"run_id\":\"\\([^\"]*\\)\".*/\\1/p'); if [ -n \"\$J\" ]; then curl -sS -m 10 -g --cacert $CA -u '$CRED' \"https://review.keplerops.test/api/review-jobs/\$J\"; echo; fi; };
P '{\"support_input\":\"ordinary-support-input-v1\"}'
P '{\"support_input\":\"ordinary-support-input-v1.json\"}'
P '{\"support_input\":\"support://reviews/ordinary-summary@1\"}'
P '{\"support_input\":\"ART-BLD-1842-ORDINARY-SUPPORT\"}'
P '{\"support_input\":\"build-results/BLD-1842/ordinary-support-input-v1.json\"}'
P '{\"support_input\":{\"schema\":\"fieldkest.review-input/v3\",\"artifact_id\":\"ART-BLD-1842-ORDINARY-SUPPORT\",\"build_revision\":\"c37effd7cc86ae4d44f18e95f899b7557d65e0a9\",\"classification\":\"support-review\",\"collection\":\"build-results/BLD-1842\",\"diagnostic_eligible\":false,\"linked_support_ref\":\"support://reviews/ordinary-summary@1\",\"object_version\":1,\"run_id\":\"BLD-1842\"}}'"
