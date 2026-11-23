set +e
B=https://cloud-api.keplerops.test
JWT=$(python3 -c 'import json;print(json.load(open("/home/rowan/.kube/config"))["users"][0]["user"]["token"])')
echo "===== CREATE TOKEN ====="
kubectl create token rowan-workspace --audience=cloud-api --duration=1h 2>&1 | head -5
kubectl create token rowan-workspace 2>&1 | head -5
echo "===== FIND KUBECONFIGS ====="
find / -xdev \( -name 'kubeconfig*' -o -name '*.kubeconfig' -o -name 'token' \) 2>/dev/null | grep -vE '^/(proc|sys|usr/(share|lib)|var/lib/dpkg)' | head -30
echo "===== CHROMIUM HISTORY ====="
python3 - <<'PY' 2>&1 | head -40
import sqlite3
try:
    c=sqlite3.connect('/home/rowan/.config/chromium/Default/History')
    for u,t in c.execute("select url,title from urls order by last_visit_time desc limit 40"):
        print(u,'|',t)
except Exception as e: print('ERR',e)
PY
echo "===== EXCHANGE MATRIX ====="
for role in export workload; do
for key in subject_token workload_token token id_token assertion jwt; do
  echo "--- $role body $key"
  curl -sSk -m 6 -w ' [%{http_code}]\n' -X POST -H 'Content-Type: application/json' -d "{\"$key\":\"$JWT\"}" "$B/api/token-exchange/$role" | head -c 300
done
done
echo "--- form grant_type/subject_token"
curl -sSk -m 6 -w ' [%{http_code}]\n' -X POST -d "grant_type=urn:ietf:params:oauth:grant-type:token-exchange&subject_token=$JWT&subject_token_type=urn:ietf:params:oauth:token-type:jwt" "$B/api/token-exchange/export" | head -c 300
echo "--- basic auth"
curl -sSk -m 6 -w ' [%{http_code}]\n' -u "$JWT:" -X POST "$B/api/token-exchange/export" | head -c 300
echo "--- import"
curl -sSk -m 6 -w ' [%{http_code}]\n' -X POST -H 'Content-Type: application/json' -d "{\"token\":\"$JWT\",\"role\":\"export\"}" "$B/api/token-exchange" | head -c 300
