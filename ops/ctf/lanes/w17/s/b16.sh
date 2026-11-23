#!/bin/bash
echo "== sn 10.50.13.0/24"; timeout 120 sudo -n nmap -sn -n 10.50.13.0/24 2>&1 | grep -E "Nmap scan report|MAC" 
echo "== arp"; cat /proc/net/arp
echo "== sn 10.50.12.0/24 10.50.14.0/24"; timeout 150 sudo -n nmap -sn -n 10.50.12.0/24 10.50.14.0/24 2>&1 | grep -E "Nmap scan report"
