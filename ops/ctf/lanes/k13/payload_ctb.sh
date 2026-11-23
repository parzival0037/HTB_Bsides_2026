set +e
echo "===== CLUSTERTRUSTBUNDLES ====="
kubectl get clustertrustbundles 2>&1 | head -20
kubectl get clustertrustbundles -o yaml 2>&1 | head -100
echo "===== raw ====="
kubectl get --raw /apis/certificates.k8s.io/v1/clustertrustbundles 2>&1 | head -c 3000; echo
echo "===== SA GET self ====="
kubectl get sa rowan-workspace -o yaml 2>&1 | head -40
echo "===== SELF SUBJECT REVIEW ====="
kubectl create -f - -o yaml <<'YAML' 2>&1 | head -40
apiVersion: authentication.k8s.io/v1
kind: SelfSubjectReview
metadata: {name: self}
YAML
echo "===== EVENTS/PODS via auth ====="
kubectl auth can-i get pods 2>&1
kubectl auth can-i get secrets 2>&1
kubectl auth can-i get clustertrustbundles 2>&1
kubectl auth can-i list clustertrustbundles 2>&1
kubectl auth can-i get configmaps --namespace fieldlink 2>&1
