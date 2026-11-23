set +e
ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=8 rowan-dev 'bash -s' <<'RSH'
set +e
echo "=== LISTEN ==="
ss -lntp 2>/dev/null | head -30
echo "=== PORT 3350 ==="
timeout 3 bash -c 'exec 3<>/dev/tcp/127.0.0.1/3350; head -c 300 <&3' 2>&1 | xxd | head -10
echo "=== KUBE DIR ==="
find ~/.kube -type f -maxdepth 3 -exec ls -la {} \; 2>/dev/null
echo "=== SEARCH KUBECONFIG/TOKENS FS ==="
ls -la /etc/rancher/k3s/ 2>/dev/null
find /home /tmp /var/lib /etc -maxdepth 4 \( -name '*kubeconfig*' -o -name '*.kubeconfig' -o -name 'token' \) 2>/dev/null | head -30
echo "=== KEPLEROPS SHARE ==="
find ~/.local/share/keplerops -type f -exec ls -la {} \; 2>/dev/null
echo "=== WORK MD FILES ==="
for f in ~/work/build-operations/*.md ~/work/analysis/staging-decoder.ps1 ~/work/fieldlink-connector/docs/*.md; do echo "##### $f"; cat "$f" 2>/dev/null | head -60; echo; done
echo "=== BASH HISTORY / CONFIG ==="
cat ~/.bash_history 2>/dev/null
echo "--- .config files"
find ~/.config -maxdepth 3 -type f 2>/dev/null | head -40
echo "--- support-client"
cat ~/.config/fieldlink/support-client.json 2>/dev/null
echo "--- npmrc"
cat ~/.npmrc 2>/dev/null
echo "=== HELPER PROBE ==="
curl -sS -m 5 http://127.0.0.1:8701/ 2>&1 | head -c 600; echo
curl -sS -m 5 http://127.0.0.1:8701/.well-known/fieldkest-client 2>&1 | head -c 600; echo
echo "=== K8S RAW RESOURCE READ TEST ==="
JWT=$(kubectl config view --raw -o jsonpath='{.users[0].user.token}')
for path in /api/v1/namespaces/fieldlink/pods /api/v1/namespaces/fieldlink/secrets /apis/apps/v1/namespaces/fieldlink/deployments /api/v1/namespaces/fieldlink/configmaps; do
 echo "-- $path"; kubectl get --raw "$path" 2>&1 | head -c 300; echo
done
RSH
echo DONE_K14_R5
