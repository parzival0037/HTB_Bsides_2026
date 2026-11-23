set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'grep -rIl --exclude-dir=.npm --exclude-dir=.cache -e "sealed" -e "seal_" -e "unseal" -e "k05" -e "Salted" $HOME /etc /opt /usr/local /var 2>/dev/null | head -30
echo "=== xattr"; getfattr -d work/registry/*.enc 2>&1 | head
echo "=== stat"; stat work/registry/k05-1-check.enc
echo "=== files with enc"; find / -name "*k05*" -o -name "*.enc" 2>/dev/null | grep -v proc | head -30
echo "=== docker/podman"; which docker podman; ls -la /var/run/docker.sock 2>&1' 2>&1 | tail -60
