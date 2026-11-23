set +e
echo "=== BOX ==="
id; hostname; ip -4 -o a
echo "=== ROWAN SERVICE NOTES ==="
ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev 'cat work/service-notes.md; echo ---PLATFORM---; cat work/platform-access.md; echo ---IDENTITY---; cat work/identity-access.md; echo ---HELPER---; cat work/local-helper.md' 2>&1
echo "=== OBJECTS HTTP ==="
curl -sS -m 10 -i http://objects.keplerops.test/ 2>&1 | head -40
echo "=== OBJECTS HTTPS ==="
curl -sSk -m 10 -i https://objects.keplerops.test/ 2>&1 | head -40
echo "=== CLOUD-API ==="
curl -sSk -m 10 -i https://cloud-api.keplerops.test/ 2>&1 | head -20
echo "=== WORKLOAD ==="
curl -sSk -m 10 -i https://workload.keplerops.test/ 2>&1 | head -20
curl -sSk -m 10 -i https://workloads.keplerops.test/ 2>&1 | head -20
echo DONE_K13_R1
