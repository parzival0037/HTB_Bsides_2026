#!/bin/bash
KO="-i ~/.ssh/keplerops-foothold -p 2222 -o StrictHostKeyChecking=no -o ConnectTimeout=10"
ssh $KO rowan@10.50.13.180 'echo "=== resolv"; cat /etc/resolv.conf; echo "=== dig arwc"; command -v dig && dig +short connector.arwc.test; dig +short @10.77.50.11 source.keplerops.test; echo "=== nmap 60.20"; timeout 120 nmap -sT -Pn -p- --min-rate 2000 10.77.60.20 2>&1 | tail -40; echo "=== nmap /24 quick"; timeout 180 nmap -sT -Pn -p 80,443,502,4840,8080,8443,5432,1883,102 --open --min-rate 3000 10.77.60.0/24 2>&1 | tail -60' 2>&1
