set +e
for h in 10.77.40.20; do
 for p in 8080 8081 8082 8083; do
  echo "##### $h:$p"
  curl -sS -m 6 -i "http://$h:$p/" 2>&1 | head -25
 done
done
echo "##### workbench index"
curl -sS -m 6 http://workbench.training:8080/ 2>&1 | head -60
echo "##### handover git"
curl -sS -m 6 -i http://workbench.training:8080/git/handover.git/ 2>&1 | head -20
