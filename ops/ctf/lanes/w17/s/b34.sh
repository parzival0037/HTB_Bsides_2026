#!/bin/bash
echo "== entrypoint"; cat /usr/local/bin/cinder-participant-entrypoint
echo "== environment"; cat /etc/environment
echo "== xsession"; cat ~/.xsession 2>/dev/null; cat /etc/xdg/xfce4/xinitrc 2>/dev/null | head
echo "== autostart"; ls -la ~/.config/autostart; for f in ~/.config/autostart/*; do echo "### $f"; cat "$f"; done
echo "== xfce panel"; ls ~/.config/xfce4/panel 2>/dev/null; grep -rioE "menu|app|url|http[^\"< ]*" ~/.config/xfce4 2>/dev/null | head -20
echo "== firefox policies"; ls /etc/firefox/policies 2>/dev/null; cat /etc/firefox/policies/* 2>/dev/null | head -40
