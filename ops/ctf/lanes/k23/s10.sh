#!/bin/bash
SSH="ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -p 2222 rowan@rowan-dev"
$SSH 'echo "=== platform-access.md"; cat ~/work/platform-access.md; echo "=== service-notes.md"; cat ~/work/service-notes.md 2>/dev/null; echo "=== work tree"; ls -la ~/work; ' 2>&1 | head -200
