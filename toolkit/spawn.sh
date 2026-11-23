#!/bin/bash
# spawn.sh <chapter> [extra instruction]
set -u
CH=$1; shift
EXTRA="${*:-}"
LANE=/home/kali/ctf/lanes/$(echo "$CH" | tr 'A-Z' 'a-z')
mkdir -p "$LANE"
{
  cat /home/kali/ctf/lanes/common.md
  echo
  echo "LANE: $CH — your chapter. Work dir: $LANE/"
  echo
  echo "Your assigned challenges (unsolved only, in order — they usually chain, so solve in"
  echo "order; each later card may depend on artefacts from the earlier one):"
  echo '```'
  /home/kali/ctf/brief.py "^$CH\." 2>/dev/null
  echo '```'
  echo
  echo "ACCESS: KeplerOps and ARWC services are reached from the range box. Start by"
  echo "checking /home/kali/ctf/lanes/k01/NETMAP.md if it exists, and by enumerating from"
  echo "the range box: /home/kali/ctf/box.py 'getent hosts; cat /etc/hosts; ssh -o BatchMode=yes rowan-dev \"ip a; cat /etc/hosts\"'."
  echo "The rowan-dev workstation (ssh rowan-dev) is your usual pivot. Tunnels must run in"
  echo "tmux on the range box. Enumerate every service you can reach before assuming a"
  echo "challenge is blocked, and record hosts/ports/creds in NETMAP.md inside your lane."
  echo
  echo "Submit flags with /home/kali/ctf/submit.py '<name>' '<flag>'. Never guess."
  echo "Finish with REPORT.md as described above."
  [ -n "$EXTRA" ] && { echo; echo "EXTRA INSTRUCTION: $EXTRA"; }
} > "$LANE/BRIEF.md"
cd "$LANE" && mkdir -p sessions && nohup pi -p "$(cat BRIEF.md)" --session-dir "$LANE/sessions" --no-extensions > run.log 2>&1 &
echo "spawned $CH -> $LANE (pid $!)"
