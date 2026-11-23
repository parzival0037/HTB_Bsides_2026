set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
CRED='rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
run(){ echo "===== $1 ====="; $S "$1" 2>&1; echo; }
P(){ curl -sS -m 10 -g --cacert $CA -u "$CRED" -i -X POST -H 'Content-Type: application/json' -d "$1" 'https://review.keplerops.test/api/jobs'; echo; }
run "P(){ curl -sS -m 10 -g --cacert $CA -u '$CRED' -i -X POST -H 'Content-Type: application/json' -d \"\$1\" 'https://review.keplerops.test/api/jobs'; echo; }; P '{\"template\":\"report-consumer-v2\"}'; P '{\"template\":\"report-consumer-v2\",\"input\":{}}'; P '{\"template\":\"report-consumer-v2\",\"input\":{\"archive_base64\":\"\"}}'; P '{\"template\":\"report-import/v1\"}'; P '{\"schema\":\"fieldkest.review-import/v1\"}'; P '{\"template\":\"review-import\"}'"
run "P(){ curl -sS -m 10 -g --cacert $CA -u '$CRED' -i -X POST -H 'Content-Type: application/json' -d \"\$1\" 'https://review.keplerops.test/api/jobs'; echo; }; P '{\"template\":\"report-consumer-v2\",\"run_id\":\"BLD-1842\"}'; P '{\"template\":\"report-consumer-v2\",\"input\":{\"run_id\":\"BLD-1842\"}}'; P '{\"job\":\"report-consumer-v2\"}'; P '{\"type\":\"report-consumer-v2\"}'"
