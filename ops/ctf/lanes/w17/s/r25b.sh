#!/bin/bash
sudo -n nmap -sn -n 10.77.40.0/24 10.77.41.0/24 2>&1 | grep -E "Nmap scan report" | head -40
echo "=== ports"
sudo -n nmap -n -p 22,80,443,1881,4840,5432,8080,8443,3000,502 --open -T4 10.77.40.0/24 10.77.41.0/24 2>&1 | grep -E "Nmap scan report|/tcp" | head -60
