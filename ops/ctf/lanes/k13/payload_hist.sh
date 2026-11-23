set +e
echo "===== BASH HISTORY ====="
cat ~/.bash_history 2>&1 | tail -100
echo "===== KUBE DIR ====="
ls -la ~/.kube/ 2>&1; find ~ -maxdepth 4 -iname '*kube*' 2>/dev/null | head -20
echo "===== FULL CAN-I LIST ====="
kubectl auth can-i --list 2>&1
echo "===== SELF RULES ====="
kubectl get --raw /apis/authorization.k8s.io/v1/selfsubjectrulesreviews -X POST -H 'Content-Type: application/json' -d '{"apiVersion":"authorization.k8s.io/v1","kind":"SelfSubjectRulesReview","spec":{"namespace":"fieldlink"}}' 2>&1 | head -c 4000; echo
