set +e
C="curl -sSk -m 20 --socks5-hostname 127.0.0.1:1080"
B=https://cloud-api.keplerops.test
K=https://cloud-api.keplerops.test:6443
U="rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
WT=$($C -u "$U" -X POST -H 'Content-Type: application/json' -d '{}' "$B/api/workspaces/current/token-exchange" | python3 -c 'import sys,json;print(json.load(sys.stdin).get("access_token",""))')
EJ=$($C -X POST -H "Authorization: Bearer $WT" -H 'Content-Type: application/json' -d '{}' "$B/api/token-exchange/fieldkest-export-access" | python3 -c 'import sys,json;print(json.load(sys.stdin).get("access_token",""))')
echo "===== jobs list"
$C -m 12 -H "Authorization: Bearer $EJ" "$K/apis/batch/v1/namespaces/fieldlink/jobs" | python3 -c 'import sys,json
try:
 d=json.load(sys.stdin)
 for i in d.get("items",[]):
  print(i["metadata"]["name"], i.get("status",{}))
except Exception as e: print("ERR",e)' 2>&1 | head -20
echo "===== latest job detail (env/annotations)"
JOB=$($C -m 12 -H "Authorization: Bearer $EJ" "$K/apis/batch/v1/namespaces/fieldlink/jobs" | python3 -c 'import sys,json
d=json.load(sys.stdin); its=d.get("items",[]); its.sort(key=lambda x:x["metadata"].get("creationTimestamp","")); print(its[-1]["metadata"]["name"] if its else "")')
echo "JOB=$JOB"
$C -m 12 -H "Authorization: Bearer $EJ" "$K/apis/batch/v1/namespaces/fieldlink/jobs/$JOB" | python3 -c 'import sys,json
d=json.load(sys.stdin); m=d.get("metadata",{}); s=d.get("spec",{});
print("annotations",json.dumps(m.get("annotations",{}))[:800]);
c=s.get("template",{}).get("spec",{}).get("containers",[{}])[0]
print("env",json.dumps(c.get("env",[]))[:1200]);
print("status",json.dumps(d.get("status",{}))[:800])' 2>&1 | head -40
echo "===== run detail probes"
for P in "api/schedules/SCHED-2841/runs/RUN-783B9475" "api/schedules/SCHED-2841/runs" "api/runs/RUN-783B9475" "api/schedule-runs/RUN-783B9475" "api/schedules/SCHED-2841/run/RUN-783B9475"; do
 echo "--- $P"; $C -m 10 -H "Authorization: Bearer $EJ" -w ' [%{http_code}]\n' "$B/$P" | head -c 700; echo
done
echo "===== pods/logs probes (may deny)"
for P in "api/v1/namespaces/fieldlink/pods" "api/v1/namespaces/fieldlink/pods?labelSelector=job-name=$JOB" "api/v1/namespaces/fieldlink/pods?labelSelector=job-name=$JOB&limit=1"; do
 echo "--- $P"; $C -m 10 -H "Authorization: Bearer $EJ" -w ' [%{http_code}]\n' "$K/$P" | head -c 500; echo
done
POD=$($C -m 10 -H "Authorization: Bearer $EJ" "$K/api/v1/namespaces/fieldlink/pods?labelSelector=job-name=$JOB" | python3 -c 'import sys,json
try:
 d=json.load(sys.stdin); its=d.get("items",[]); print(its[0]["metadata"]["name"] if its else "")
except Exception: print("")')
echo "POD=$POD"
[ -n "$POD" ] && for c in exporter; do echo "--- log $POD/$c"; $C -m 10 -H "Authorization: Bearer $EJ" -w ' [%{http_code}]\n' "$K/api/v1/namespaces/fieldlink/pods/$POD/log?container=$c" | head -c 1000; echo; done
