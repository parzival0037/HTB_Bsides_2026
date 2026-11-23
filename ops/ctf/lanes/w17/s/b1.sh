#!/bin/bash
echo "== whoami"; id; hostname
echo "== hosts"; cat /etc/hosts; cat /etc/resolv.conf
echo "== home"; ls -la ~; echo; ls -la ~/CairnReach 2>&1
echo "== find"; find ~ -maxdepth 4 -path '*CairnReach*' 2>/dev/null | head -60
echo "== listening"; ss -lntup 2>/dev/null | head -40 || netstat -lntup 2>/dev/null | head -40
echo "== docker"; which docker podman; sudo -n docker ps 2>&1 | head -20
echo "== getent"; for h in hmi.arwc.test plc arwc.test opcua historiam historian db postgres; do echo "$h => $(getent hosts $h|head -1)"; done
echo "== ps"; ps aux | head -30
