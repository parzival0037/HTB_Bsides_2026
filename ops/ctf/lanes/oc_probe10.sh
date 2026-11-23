set +e
C="curl -sSk -m 20 --socks5-hostname 127.0.0.1:1080"
B=https://cloud-api.keplerops.test
K=https://cloud-api.keplerops.test:6443
U="rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
WT=$($C -u "$U" -X POST -H 'Content-Type: application/json' -d '{}' "$B/api/workspaces/current/token-exchange" | python3 -c 'import sys,json;print(json.load(sys.stdin).get("access_token",""))')
EJ=$($C -X POST -H "Authorization: Bearer $WT" -H 'Content-Type: application/json' -d '{}' "$B/api/token-exchange/fieldkest-export-access" | python3 -c 'import sys,json;print(json.load(sys.stdin).get("access_token",""))')
$C -m 12 -H "Authorization: Bearer $EJ" "$K/apis/batch/v1/namespaces/fieldlink/cronjobs/sched-2841" > /tmp/cj.json
python3 - <<'PY'
import json
d=json.load(open('/tmp/cj.json'))
s=d.get('spec',{}); ps=s.get('jobTemplate',{}).get('spec',{}).get('template',{}).get('spec',{})
print("annotations:",json.dumps(d.get('metadata',{}).get('annotations',{})))
print("status:",json.dumps(d.get('status',{})))
print("podspec keys:",list(ps.keys()))
print("serviceAccountName:",ps.get('serviceAccountName'))
print("volumes:",json.dumps(ps.get('volumes')))
for c in ps.get('containers',[]):
    print("KEYS",list(c.keys()))
    print("envFrom:",json.dumps(c.get('envFrom')))
    print("command:",json.dumps(c.get('command')))
    print("env:",json.dumps(c.get('env')))
PY
echo "===== role exchange probes (schedule runner)"
for R in fieldkest-schedule-access fieldkest-schedule-runner schedule-runner schedule-access support-schedule fieldkest-startup-access; do
 echo "--- $R"; $C -m 8 -X POST -H "Authorization: Bearer $EJ" -H 'Content-Type: application/json' -d '{}' -w ' [%{http_code}]\n' "$B/api/token-exchange/$R" | head -c 400; echo
done
echo "===== trust records probes"
for T in TRUST-FLX-01 TRUST-FLX-02 TRUST-FLX-03 TRUST-FLX-04 TRUST-FLX-05 TRUST-SCHED-01; do
 echo "--- $T"; $C -m 8 -H "Authorization: Bearer $EJ" -w ' [%{http_code}]\n' "$B/api/trust-records/$T" | head -c 300; echo
done
