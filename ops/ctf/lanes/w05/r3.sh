#!/bin/bash
H='ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ConnectTimeout=8 -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180'
$H 'cat /etc/resolv.conf; echo "--- dns test"; for n in connector.arwc.test arwc.test portal.arwc.test staff.arwc.test onboarding.arwc.test hr.arwc.test id.arwc.test auth.arwc.test dir.arwc.test ldap.arwc.test; do printf "%s: " $n; getent hosts $n || echo NO; done; echo "--- dig"; command -v dig >/dev/null && dig +short arwc.test SOA; dig +short arwc.test AXFR @$(awk "/^nameserver/{print \$2;exit}" /etc/resolv.conf) 2>&1 | head -40'
echo "=== nmap 10.77.60.20"
$H 'sudo -n nmap -sT -Pn -p- --min-rate 3000 -T4 10.77.60.20 2>/dev/null | tail -40' 2>&1 | tail -45
