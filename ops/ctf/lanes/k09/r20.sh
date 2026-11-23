set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
CRED='rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
run(){ echo "===== $1 ====="; $S "$1" 2>&1; echo; }
run "P(){ echo \"### \$1\"; curl -sS -m 10 -g --cacert $CA -u '$CRED' -X POST -H 'Content-Type: application/json' -d \"\$1\" 'https://review.keplerops.test/api/review-jobs'; echo; };
P '{\"support_input\":\"ART-BLD-1842-INTEGRATION-REVIEW\"}'
P '{\"support_input\":\"integration-review-input-v3.json\"}'
P '{\"support_input\":\"/api/runs/BLD-1842/artifacts/integration-review-input-v3.json\"}'
P '{\"support_input\":\"build-results/BLD-1842/integration-review-input-v3.json\"}'
P '{\"support_input\":{\"artifact_id\":\"ART-BLD-1842-INTEGRATION-REVIEW\"}}'
P '{\"support_input\":{\"run_id\":\"BLD-1842\",\"name\":\"integration-review-input-v3.json\"}}'
P '{\"support_input\":{\"run_id\":\"BLD-1842\",\"object\":\"integration-review-input-v3.json\"}}'
P '{\"support_input\":{\"run_id\":\"BLD-1842\",\"collection\":\"build-results/BLD-1842\",\"object\":\"integration-review-input-v3.json\"}}'"
