set +e
echo "=== HOSTS ==="
getent hosts rowan-dev assistant.keplerops.test llm.keplerops.test 2>&1
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
A=https://assistant.keplerops.test
echo "########## ROOT"
curl -sS -m 8 --cacert $CA -i $A/ 2>&1 | head -15
for p in /api/ping /api/system/check /api/system /api/settings /api/workspaces /api/v1/workspaces /api/v1/admin/workspaces /api/admin/workspaces /api/workspace /api/system/env /api/env /api/system/configuration /.env /api/docs /api/openapi.json; do
  echo "########## GET $p"
  curl -sS -m 8 --cacert $CA -i "$A$p" 2>&1 | head -25
  echo
done
echo "########## OLLAMA"
for p in / /api/tags /api/ps /api/version; do echo "--- $p"; curl -sS -m 8 --cacert $CA -i "https://llm.keplerops.test$p" 2>&1 | head -20; done
echo "########## KUBE"
export KUBECONFIG=/home/rowan/.kube/config
kubectl get all -n fieldlink 2>&1 | head -60
echo "--- pods wide"
kubectl get pods -n fieldlink -o wide 2>&1 | head -30
echo "--- configmaps/secrets"
kubectl get configmaps,secrets -n fieldlink 2>&1 | head -40
INNER
