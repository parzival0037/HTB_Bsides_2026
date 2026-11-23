ssh rowan-dev 'psql service=fieldlink -c "\dn" 2>&1; echo "=== tables"; psql service=fieldlink -c "\dt *.*" 2>&1 | head -80'
