#!/bin/bash
H=accounts.training
for p in /candidates.md /directory/ /directory /api/directory /api/staff /staff /api/lookup; do
  echo "===== $p ====="
  curl -s -i --max-time 15 "http://$H:8080$p"
  echo
done
