set +e
C="curl -sSk -m 20 --socks5-hostname 127.0.0.1:1080"
B=https://cloud-api.keplerops.test
K=https://cloud-api.keplerops.test:6443
U="rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
WT=$($C -u "$U" -X POST -H 'Content-Type: application/json' -d '{}' "$B/api/workspaces/current/token-exchange" | python3 -c 'import sys,json;print(json.load(sys.stdin).get("access_token",""))')
EJ=$($C -X POST -H "Authorization: Bearer $WT" -H 'Content-Type: application/json' -d '{}' "$B/api/token-exchange/fieldkest-export-access" | python3 -c 'import sys,json;print(json.load(sys.stdin).get("access_token",""))')
echo "===== SSRR rest"
$C -m 12 -X POST -H "Authorization: Bearer $EJ" -H 'Content-Type: application/json' \
 -d '{"apiVersion":"authorization.k8s.io/v1","kind":"SelfSubjectRulesReview","spec":{"namespace":"fieldlink"}}' \
 "$K/apis/authorization.k8s.io/v1/selfsubjectrulesreviews" | python3 -c 'import sys,json; d=json.load(sys.stdin); rr=d.get("status",{}).get("resourceRules",[]); print(json.dumps(rr[8:],indent=1))' 2>&1 | head -160
echo "===== JOB exp-2841"
$C -m 12 -H "Authorization: Bearer $EJ" "$K/apis/batch/v1/namespaces/fieldlink/jobs/exp-2841" > /tmp/job.json
python3 - <<'PY'
import json
d=json.load(open('/tmp/job.json'))
m=d.get('metadata',{}); s=d.get('spec',{})
print("annotations",json.dumps(m.get('annotations',{}))[:1200])
ps=s.get('template',{}).get('spec',{})
print("sa",ps.get('serviceAccountName'))
for c in ps.get('containers',[]):
    print("container",c.get('name'),"image",c.get('image'))
    print("command",json.dumps(c.get('command'))[:1500])
    print("env",json.dumps(c.get('env',[]))[:2000])
print("status",json.dumps(d.get('status',{}))[:800])
PY
echo "===== pods for exp-2841"
$C -m 10 -H "Authorization: Bearer $EJ" -w '\n[%{http_code}]\n' "$K/api/v1/namespaces/fieldlink/pods?labelSelector=job-name=exp-2841" | head -c 1200; echo
echo "===== pod guesses log"
for P in exp-2841 exp-2841-xxxxx sched-2841 exp-2841-run; do
 echo "--- $P"; $C -m 8 -H "Authorization: Bearer $EJ" -w ' [%{http_code}]\n' "$K/api/v1/namespaces/fieldlink/pods/$P/log" | head -c 400; echo
done
