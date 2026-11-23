#!/bin/bash
# fleet.sh <queue-file> <max-concurrent> [retries]
# Small, rate-limit-aware fleet: one headless pi lane per chapter, at most MAX alive.
# The post-launch settle time is adaptive: it shrinks while launches stay clean and
# doubles (up to 60s) when the provider answers 429.
Q=$1; MAX=${2:-3}; RETRIES=${3:-4}; MODEL=${MODEL:-}; WAIT=${WAIT:-8}

active() {
  # count DISTINCT lane directories with a live process, not raw processes
  for d in /proc/[0-9]*; do
    c=$(readlink "$d/cwd" 2>/dev/null) || continue
    case "$c" in /home/kali/ctf/lanes/*) echo "${c#/home/kali/ctf/lanes/}";; esac
  done | cut -d/ -f1 | sort -u | wc -l
}

rate_limited() { grep -qiE 'rate_limit_error|429|Connection error|Request aborted' "$1/run.log" 2>/dev/null; }

while read -r CH; do
  [ -z "$CH" ] && continue
  case "$CH" in \#*) continue;; esac
  LANE=/home/kali/ctf/lanes/$(echo "$CH" | tr 'A-Z' 'a-z')
  [ -f "$LANE/DONE" ] && { echo "skip $CH (done)"; continue; }

  attempt=0
  while : ; do
    attempt=$((attempt+1))
    while [ "$(active)" -ge "$MAX" ]; do sleep 10; done

    mkdir -p "$LANE/sessions"
    {
      cat /home/kali/ctf/lanes/common.md
      echo
      echo "LANE: $CH — your chapter. Work dir: $LANE/"
      echo
      echo "Your assigned challenges (unsolved only, in order — they usually chain):"
      echo '```'
      /home/kali/ctf/brief.py "^$CH\." 2>/dev/null
      echo '```'
      echo
      echo "Submit with /home/kali/ctf/submit.py '<name>' '<flag>'. Never guess a flag."
      echo "Finish or get blocked -> write REPORT.md, then 'touch $LANE/DONE'."
    } > "$LANE/BRIEF.md"

    ( cd "$LANE" && setsid nohup pi -p "$(cat BRIEF.md)" --session-dir "$LANE/sessions" \
        ${MODEL:+--model "$MODEL"} --no-extensions > run.log 2>&1 < /dev/null & )
    sleep "$WAIT"

    if rate_limited "$LANE"; then
      [ "$WAIT" -lt 60 ] && WAIT=$(( WAIT * 2 ))
      echo "$(date +%H:%M:%S) $CH rate-limited (attempt $attempt) — settle now ${WAIT}s"
      pkill -f "ctf/lanes/$(echo "$CH" | tr 'A-Z' 'a-z')/sessions" 2>/dev/null
      if [ "$attempt" -ge "$RETRIES" ]; then echo "$CH gave up"; break; fi
      back=$(( 20 * attempt )); [ "$back" -gt 90 ] && back=90
      sleep "$back"
      continue
    fi

    # clean launch: tighten the settle time for the next one
    [ "$WAIT" -gt 3 ] && WAIT=$(( WAIT > 5 ? WAIT - 2 : 3 ))
    echo "$(date +%H:%M:%S) launched $CH model=${MODEL:-default} (active $(active), settle ${WAIT}s)"
    break
  done
  sleep 1
done < "$Q"
echo "$(date +%H:%M:%S) queue drained"
