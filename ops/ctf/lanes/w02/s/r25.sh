set +e
B=http://10.77.40.20
for p in / /index.md /README.md /markdown /docs/ /git/ /git/handover.git/ /handover.git/ /repos/ /robots.txt; do
 echo "##### $p"; curl -sS -i --max-time 10 "$B:8080$p" | head -c 2000; echo; done
echo "##### git ls-remote variants"
for u in "$B:8080/git/handover.git" "$B:8080/handover.git" "$B:8080/handover" "$B:8080/git/handover" "$B:8081/handover.git" "$B:8081/git/handover.git"; do
 echo "--- $u"; timeout 20 git ls-remote "$u" 2>&1 | head -20; done
