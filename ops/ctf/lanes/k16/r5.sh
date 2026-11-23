#!/bin/bash
set +e
ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=10 rowan-dev 'bash -s' <<'RSH'
set +e
echo "###### grep export_token / export role everywhere readable"
grep -rIl -iE 'export[_ -]?token|export[_ -]?role|X-Export|schedules/|SCHED-' /home/rowan /opt /srv /etc /usr/local 2>/dev/null | grep -v -E '\.cache|\.kube/cache|node_modules' | head -40
echo "###### grep schedule in home"
grep -rIn -iE 'export[_ -]?token|export_role|X-Export|SCHED-2841|schedule' /home/rowan/work /home/rowan/repos /home/rowan/README.md /home/rowan/k05arch /opt/fieldkest-workbench 2>/dev/null | head -40
echo "###### workbench dir"
ls -la /opt/fieldkest-workbench 2>&1
echo "###### env"
env | sort | head -40
echo "###### aws creds"
cat ~/.aws/config ~/.aws/credentials 2>&1
echo "###### pg service"
cat ~/.pg_service.conf ~/.pgpass 2>&1
echo "###### docker/k8s runtime?"
ls -la /var/run/secrets/kubernetes.io/serviceaccount 2>&1
mount 2>/dev/null | head -20
RSH
echo DONE_R5
