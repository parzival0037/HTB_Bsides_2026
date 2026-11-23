set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
echo "===== reach from KALI box ====="
for t in 10.77.50.11 10.77.51.20 10.77.51.30 10.77.51.40 10.77.51.41 10.77.51.50 10.77.51.70 10.77.60.20; do
  timeout 2 bash -c "echo > /dev/tcp/$t/80" 2>/dev/null && echo "$t:80 OPEN" || echo "$t:80 closed"
done
echo "===== docs ====="
$S 'for f in work/identity-access.md work/platform-access.md work/local-helper.md; do echo "########## $f"; cat $f; echo; done'
echo "===== service-notes (head) ====="
$S 'head -70 work/service-notes.md'
