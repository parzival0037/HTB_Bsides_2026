#!/bin/bash
ssh -o StrictHostKeyChecking=no -o BatchMode=yes -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180 'cat /etc/hosts; echo "### resolv"; cat /etc/resolv.conf; echo "### ips"; ip -4 a 2>/dev/null | head -30'
