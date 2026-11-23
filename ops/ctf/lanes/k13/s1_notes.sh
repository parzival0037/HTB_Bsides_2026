set +e
echo "===== ROWAN WORK DIR ====="
ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev 'ls -la work/ 2>&1; echo ---; find work -type f | head -60' 2>&1
echo "===== GREP WORKLOAD/IDENTITY/RECORD IN NOTES ====="
ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev 'grep -rniE "workload|identity|protected|record|scope|workspace token|token-exchange" work/ 2>/dev/null | head -80' 2>&1
echo "===== ROWAN /tmp leftovers ====="
ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev 'ls -la /tmp/ | head -40' 2>&1
echo "===== BOX /tmp leftovers ====="
ls -la /tmp/ | grep -i k13 | head -40
echo "===== BUCKET LIST workspace ====="
curl -sS --socks5-hostname 127.0.0.1:1080 -k -m 20 "https://objects.keplerops.test/fieldkest-workspaces?list-type=2" | sed 's/></>\n</g' | grep -E '<Key>|<VersionId>|<Size>' | head -80
echo "===== BUCKET VERSIONS ====="
curl -sS --socks5-hostname 127.0.0.1:1080 -k -m 20 "https://objects.keplerops.test/fieldkest-workspaces?versions" | sed 's/></>\n</g' | grep -E '<Key>|<VersionId>|<IsLatest>' | head -80
