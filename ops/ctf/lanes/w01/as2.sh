#!/bin/bash
S="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$S 'cat > /tmp/as2.sh' <<'EOS'
#!/bin/bash
C="curl -sS -k --max-time 20"
echo "##### config"; $C https://assistant.keplerops.test/api/config; echo
echo "##### contexts"; $C https://assistant.keplerops.test/api/contexts; echo
echo "##### conv SUP"; $C https://assistant.keplerops.test/api/conversations/CONV-SUP-2841-19; echo
echo "##### selection"; $C https://assistant.keplerops.test/api/selections/SEL-SUP-2841-12; echo
echo "##### document"; $C https://assistant.keplerops.test/api/contexts/ctx-support-private-v4/conversations/CONV-SUP-2841-19/documents/DOC-RILL-442; echo
echo "##### conv rill"; $C https://assistant.keplerops.test/api/conversations/CONV-RILL-442-8; echo
EOS
chmod +x /tmp/as2.sh
$S 'bash /tmp/as2.sh' 2>&1 | sed -n '/#####/,$p' | head -120
