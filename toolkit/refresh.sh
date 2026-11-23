#!/bin/bash
while true; do
  /usr/bin/python3 /home/kali/ctf/claims.py > /tmp/claims.log 2>&1
  /usr/bin/python3 /home/kali/ctf/kanban.py >> /tmp/kanban_refresh.log 2>&1
  sleep 30
done
