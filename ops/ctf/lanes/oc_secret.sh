set +e
ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=15 rowan-dev 'bash -s' <<'RSH'
set +e
echo "== whoami"; kubectl config current-context; kubectl auth whoami 2>&1 | head -5
echo "== can-i list"; kubectl auth can-i --list -n fieldlink 2>&1 | head -40
echo "== secret get"; kubectl -n fieldlink get secret sched-2841-runner-credentials -o json 2>&1 | head -c 3000; echo
echo "== secret get specific perms"; kubectl auth can-i get secrets -n fieldlink 2>&1; kubectl auth can-i get secret/sched-2841-runner-credentials -n fieldlink 2>&1
echo "== cronjob"; kubectl -n fieldlink get cronjob sched-2841 -o jsonpath='{.spec.jobTemplate.spec.template.spec.containers[0].envFrom}' 2>&1; echo
RSH
