#!/bin/bash
ssh -o StrictHostKeyChecking=no -o BatchMode=yes -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180 'cat ~/.pg_service.conf; echo "### schemas"; psql service=fieldlink -c "\dn" 2>&1; echo "### tables"; psql service=fieldlink -c "\dt *.*" 2>&1 | head -80'
