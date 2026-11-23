#!/bin/bash
S="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$S 'cat > /tmp/dump.sh' <<'EOS'
#!/bin/bash
cd /tmp
aws --endpoint-url https://objects.keplerops.test s3 cp s3://fieldlink-exports/backups/company-history.dump . 2>&1 | tail -2
ls -l company-history.dump
file company-history.dump
echo "### pg_restore -l"
pg_restore -l company-history.dump 2>&1 | head -60
echo "### strings"
strings -n 4 company-history.dump | head -100
EOS
chmod +x /tmp/dump.sh
$S 'bash /tmp/dump.sh' 2>&1 | head -200
