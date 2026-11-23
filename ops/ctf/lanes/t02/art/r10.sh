#!/bin/bash
H=accounts.training
echo "=== options ==="
curl -s -i -X OPTIONS --max-time 10 "http://$H:8080/api/assignments/ASG-317/brief"; echo
echo "=== ffuf available? ==="; which ffuf gobuster feroxbuster dirb 2>/dev/null
echo "=== wordlists ==="; ls /usr/share/wordlists/ 2>/dev/null; ls /usr/share/seclists/Discovery/Web-Content/ 2>/dev/null | head
