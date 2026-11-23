set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'RSH'
set +e
echo "===RESOLVE ALL==="
for n in k-dev.keplerops.test edge.keplerops.test foundation.keplerops.test source.keplerops.test source-tools.keplerops.test git.keplerops.test packages.keplerops.test delivery.keplerops.test registry.keplerops.test ci.keplerops.test review.keplerops.test jenkins.keplerops.test preview.keplerops.test support.keplerops.test tickets.keplerops.test indexer.keplerops.test staff.keplerops.test workboard.keplerops.test identity.keplerops.test id.keplerops.test cert.keplerops.test ca.keplerops.test cloud.keplerops.test cloud-api.keplerops.test data.keplerops.test objects.keplerops.test workload.keplerops.test workloads.keplerops.test assistant.keplerops.test llm.keplerops.test kerberos.keplerops.test connector.arwc.test; do echo -n "$n = "; getent hosts $n | awk '{print $1}' | tr '\n' ' '; echo; done
echo "===BODIES==="
for hp in 10.77.51.60:443 10.77.51.70:443 10.77.51.41:443 10.77.51.50:443 10.77.60.20:443 10.77.50.11:8443; do echo "--- $hp ---"; curl -sS -m 6 -k "https://$hp/" | head -c 400; echo; done
echo "===PORTSCAN 60.0/24 + 52.0/24 wider==="
python3 - <<'PY'
import socket,concurrent.futures
ports=[21,22,23,25,53,80,110,111,143,389,443,445,587,636,993,995,1080,1433,1521,2049,2375,2376,3000,3260,3306,3389,4000,5000,5432,5555,5601,5672,5900,5985,5986,6379,6443,7000,8000,8008,8080,8081,8088,8443,8888,9000,9090,9200,9443,10000,11211,27017]
def chk(a,p):
    s=socket.socket(); s.settimeout(0.5)
    try: s.connect((a,p)); return (a,p)
    except Exception: return None
    finally: s.close()
jobs=[(f'10.77.60.{i}',p) for i in range(1,255) for p in ports]+[(f'10.77.52.{i}',p) for i in range(1,255) for p in ports]
res=[]
with concurrent.futures.ThreadPoolExecutor(max_workers=300) as ex:
    for r in ex.map(lambda x: chk(*x), jobs, chunksize=16):
        if r: res.append(r)
for a,p in sorted(res,key=lambda t:(t[0],t[1])): print('OPEN',a,p)
PY
RSH
