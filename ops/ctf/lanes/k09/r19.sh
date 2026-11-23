set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
CRED='rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
run(){ echo "===== $1 ====="; $S "$1" 2>&1; echo; }
run "P(){ echo \"### \$1\"; curl -sS -m 10 -g --cacert $CA -u '$CRED' -i -X POST -H 'Content-Type: application/json' -d \"\$1\" 'https://review.keplerops.test/api/review-jobs'; echo; }; P '{}'; P '{\"schema\":\"fieldkest.review-import/v1\"}'; P '{\"schema\":\"fieldkest.review-import/v1\",\"run_id\":\"BLD-1842\"}'; P '{\"schema\":\"fieldkest.review-import/v1\",\"run_id\":\"BLD-1842\",\"object\":\"ART-BLD-1842-INTEGRATION-REVIEW\"}'; P '{\"schema\":\"fieldkest.review-import/v1\",\"run_id\":\"BLD-1842\",\"inputs\":{\"object\":\"ART-BLD-1842-INTEGRATION-REVIEW\"}}'"
run "for R in BLD-1842 BLD-REL-742; do echo \"### GET \$R\"; curl -sS -m 10 -g --cacert $CA -u '$CRED' -i \"https://review.keplerops.test/api/review-jobs/\$R\"; echo; done"
