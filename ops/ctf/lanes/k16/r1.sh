#!/bin/bash
set +e
R(){ echo "##### $1"; ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=10 rowan-dev "$1" 2>&1; }
R 'id; hostname; date -u; cat /etc/hostname'
R 'ls -la ~; echo ---; ls -la ~/work 2>&1; echo ---; ls -la ~/samples 2>&1'
R 'crontab -l 2>&1; echo ---; sudo -n crontab -l 2>&1; echo ---; cat /etc/crontab 2>&1; echo ---; ls -la /etc/cron.d /etc/cron.daily /etc/cron.hourly 2>&1'
R 'systemctl list-timers --all 2>&1 | head -40; echo ---; systemctl --user list-timers --all 2>&1 | head -40; echo ---; systemctl list-units --type=service --all 2>&1 | head -60'
R 'ls -la ~/.config/systemd/user 2>&1; echo ---; cat ~/.config/systemd/user/* 2>&1 | head -100'
R 'kubectl config current-context 2>&1; kubectl get cronjobs -A 2>&1; echo ---; kubectl get jobs -A 2>&1 | head; echo ---; kubectl get all -n fieldlink 2>&1 | head -60'
R 'ls -la ~/work; echo ---; for f in ~/work/*.md; do echo "=== $f"; head -100 "$f"; done'
echo DONE_R1
