set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'RSH'
set +e
echo "===IDENTITY/PRIV==="; id; sudo -n true 2>&1; echo "sudo_rc=$?"
echo "===USERS==="; cat /etc/passwd | tail -12; ls -la /home
echo "===PROCS==="; ps aux 2>/dev/null | head -30
echo "===DOCKER==="; which docker podman kubectl psql aws step kinit 2>&1; ls -la /var/run/docker.sock /run/docker.sock 2>&1; docker ps 2>&1 | head -5
echo "===VPN==="; ls -la /etc/wireguard /etc/openvpn 2>&1; ip link | head -20
echo "===KERB==="; cat /etc/krb5.conf 2>&1 | head -40; klist 2>&1 | head -5
echo "===SSHCFG==="; ls -la /etc/ssh/ssh_config.d 2>&1; cat /etc/ssh/ssh_config 2>&1 | grep -v '^#' | grep -v '^$'; echo ---; cat ~/.ssh/authorized_keys; echo ---; find / -maxdepth 4 -name 'id_*' -o -maxdepth 4 -name '*.pem' 2>/dev/null | head -20
echo "===KEPLEROPS-DIR==="; find ~/.local/share/keplerops -maxdepth 3 2>/dev/null | head -30
echo "===CHROMIUM-PREFS==="; python3 -c "import json;d=json.load(open('/home/rowan/.config/chromium/Default/Preferences'));print(json.dumps(d,indent=1)[:3000])" 2>&1
RSH
