#!/bin/bash
# switch_model.sh <model> <lane> [lane...]
# Restarts each lane's most recent session on a different model, keeping context.
MODEL=$1; shift
for L in "$@"; do
  LANE=/home/kali/ctf/lanes/$(echo "$L" | tr 'A-Z' 'a-z')
  [ -d "$LANE/sessions" ] || continue
  for p in $(ls /proc | grep -E '^[0-9]+$'); do
    d=$(readlink /proc/$p/cwd 2>/dev/null)
    case "$d" in "$LANE"/*) kill -9 "$p" 2>/dev/null;; esac
  done
  sleep 1
  ( cd "$LANE" && setsid nohup pi -c -p "Continue your assigned chapter from where you stopped. Re-read REPORT.md/notes.md first. Do not unlock hints. Submit only when the flag is certain." \
      --session-dir "$LANE/sessions" --model "$MODEL" --no-extensions > run.log 2>&1 < /dev/null & )
  echo "$(date +%H:%M:%S) $L -> $MODEL"
  sleep 3
done
