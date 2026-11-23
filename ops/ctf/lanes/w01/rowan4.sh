#!/bin/bash
ssh -o StrictHostKeyChecking=no -o BatchMode=yes -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180 'cd ~/repos/connector-archive; echo "### tree"; find . -not -path "./.git/*" -printf "%y %8s %p\n" | head -100; echo "### git log"; cd connector-archive && git log --oneline --all 2>/dev/null | head; echo "### README"; cat README.md 2>/dev/null'
