#!/bin/bash
echo "== grep arwc/cairn/hmi globally (small files)"
timeout 180 sudo -n grep -rIl -E "arwc\.test|CairnReach|Cairn Reach|hmi\.arwc|CRR\.Position|ot_history|OpenPLC|FUXA" /etc /opt /srv /usr/local /var/lib /home /root /run 2>/dev/null | grep -v -E "BurpSuite|burpbrowser" | head -40
echo "== side menu search"
timeout 60 sudo -n grep -rIl "Ctrl+Alt+Shift\|side menu\|browser desktop" /etc /usr/local /opt /home /root 2>/dev/null | grep -v BurpSuite | head -20
echo "== recent files in /etc"; ls -la /etc | head -40
echo "== /usr/local"; ls -la /usr/local; ls -la /usr/local/bin | head -40
