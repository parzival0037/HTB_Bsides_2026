#!/bin/bash
S="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$S 'cat > /tmp/dump2.sh' <<'EOS'
#!/bin/bash
cd /tmp
pg_restore -f /tmp/company.sql company-history.dump 2>&1 | head -5
wc -l /tmp/company.sql
sed -n '1,400p' /tmp/company.sql
EOS
chmod +x /tmp/dump2.sh
$S 'bash /tmp/dump2.sh' 2>&1 | head -250
