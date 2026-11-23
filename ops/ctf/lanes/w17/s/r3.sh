cat ~/.ssh/config
echo ---
head -3 ~/.ssh/keplerops-foothold
echo ---
for u in rowan cinder; do ssh -i ~/.ssh/keplerops-foothold -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=6 -p 2222 $u@10.50.13.180 'hostname; id' 2>&1 | tail -3; done
echo ---
ssh -i ~/.ssh/keplerops-foothold -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=6 -p 2222 rowan@rowan-dev 'hostname; id' 2>&1 | tail -3
