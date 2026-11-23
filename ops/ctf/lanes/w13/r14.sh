#!/bin/bash
T='fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b'
echo "=== gobuster common on edge ==="
timeout 300 gobuster dir -u https://10.77.51.60 -k --proxy socks5://127.0.0.1:1080 -H "Authorization: Bearer $T" -w /usr/share/seclists/Discovery/Web-Content/common.txt -b 404 -t 30 --timeout 8s --no-error 2>&1 | tail -80
echo "=== gobuster api/ prefix ==="
timeout 300 gobuster dir -u https://10.77.51.60/api -k --proxy socks5://127.0.0.1:1080 -H "Authorization: Bearer $T" -w /usr/share/seclists/Discovery/Web-Content/common.txt -b 404 -t 30 --timeout 8s --no-error 2>&1 | tail -60
