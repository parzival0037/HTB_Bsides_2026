#!/bin/bash
ls /usr/share/wordlists /usr/share/dirb/wordlists /usr/share/seclists 2>/dev/null | head
if [ ! -f /usr/share/wordlists/common.txt ]; then
  sudo apt-get install -y -qq seclists 2>/dev/null | tail -2
fi
ls /usr/share/seclists/Discovery/Web-Content/ 2>/dev/null | head
