#!/bin/bash
SSH="ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -i $HOME/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$SSH 'bash -s' <<'INNER'
echo "===== listening"
(ss -tlnp 2>/dev/null || netstat -tlnp 2>/dev/null) | head -40
echo "===== who am i / sudo"
id; sudo -n true 2>&1 && echo SUDO_OK || echo NO_SUDO
echo "===== docker"
docker ps 2>&1 | head -20; ls -la /var/run/docker.sock 2>&1
echo "===== top dirs"
ls -la / ; echo "--- opt"; ls -la /opt /srv /app /var/www 2>/dev/null | head -60
echo "===== processes"
ps aux --sort=-rss 2>/dev/null | head -30
echo "===== psql service"
cat ~/.pg_service.conf 2>&1; ls -la ~/.pgpass 2>&1
echo "===== port 3350 identify"
timeout 4 bash -c "exec 3<>/dev/tcp/127.0.0.1/3350; head -c 200 <&3" 2>&1 | xxd | head -5
echo "===== port 8701 root + openapi"
curl -sS -m 8 -i http://127.0.0.1:8701/ 2>&1 | head -30
curl -sS -m 8 http://127.0.0.1:8701/openapi.json 2>&1 | head -c 800; echo
echo "===== grep filesystem for keywords"
grep -rniIl --exclude-dir=proc --exclude-dir=sys --exclude-dir=dev --exclude-dir=usr --exclude-dir=lib --exclude-dir=lib64 --exclude-dir=snap "report assistant\|source-selection\|linked-document\|district\|planning excerpt" / 2>/dev/null | head -40
INNER
