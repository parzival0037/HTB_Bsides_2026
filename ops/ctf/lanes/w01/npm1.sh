#!/bin/bash
S="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$S 'cd /tmp; npm view @keplerops/support-rehearsal --json 2>&1 | head -100; echo "### versions"; npm view @keplerops/support-rehearsal versions --json 2>&1; echo "### fieldlink versions"; npm view @keplerops/fieldlink-connector versions --json 2>&1 | tail -20'
