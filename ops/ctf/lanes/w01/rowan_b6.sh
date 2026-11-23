#!/bin/bash
S="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$S 'cat > /tmp/b6.sh' <<'EOS'
#!/bin/bash
C="curl -sS -k --max-time 15"
T="fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b"
K=$(grep -oP 'token: \K.*' ~/.kube/config)
echo "### support handover current (bearer)"; $C -i -H "Authorization: Bearer $T" https://support.keplerops.test:8443/api/handovers/current | head -c 3000; echo
echo "### support handover current (no auth)"; $C -i https://support.keplerops.test:8443/api/handovers/current | head -c 600; echo
echo "### cloud maintenance bearer"; $C -i -H "Authorization: Bearer $T" https://cloud-api.keplerops.test/api/maintenance | head -c 1500; echo
echo "### cloud maintenance k8s token"; $C -i -H "Authorization: Bearer $K" https://cloud-api.keplerops.test/api/maintenance | head -c 1500; echo
echo "### cloud workspace exchange GET"; $C -i -H "Authorization: Bearer $K" https://cloud-api.keplerops.test/api/workspaces/current/token-exchange | head -c 1500; echo
EOS
chmod +x /tmp/b6.sh
$S 'bash /tmp/b6.sh' 2>&1 | head -180
