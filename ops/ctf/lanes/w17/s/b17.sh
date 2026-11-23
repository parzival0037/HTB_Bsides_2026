#!/bin/bash
echo "== sn 10.50.13.0/24"; timeout 150 sudo -n nmap -sn -n 10.50.13.0/24 2>&1 | grep -E "Nmap scan report"
