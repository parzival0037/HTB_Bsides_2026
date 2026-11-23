#!/bin/bash
SSH="ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -i $HOME/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$SSH 'bash -s' <<'INNER'
F=/tmp/al/index.js
echo "=== document api strings"
grep -oE '\$\{C\}/document[^`"]*' $F | sort -u | head -50
grep -oE '\$\{C\}/workspace/\$\{[a-z]\}/[a-z-]+' $F | sort -u | head -80
grep -oE 'fetch\(`\$\{[A-Za-z]+\}/[^`]+`' $F | sort -u | head -100
echo "=== workspace methods context"
grep -oE '.{60}getAllDocuments.{200}' $F | head -10
grep -oE '.{80}view.{0,40}document.{120}' $F | head -10
grep -oE '.{100}chunk.{0,40}source.{150}' $F | head -10
echo "=== routes 'document'"
grep -oE '`[^`]*document[^`]*`' $F | sort -u | head -80
INNER
