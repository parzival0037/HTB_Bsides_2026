#!/bin/bash
SSH="ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -p 2222 rowan@rowan-dev"
$SSH 'getent hosts assistant.keplerops.test; python3 -V; python3 -c "import requests;print(\"requests ok\")" 2>&1; python3 -c "import websockets;print(\"websockets\",websockets.__version__)" 2>&1; python3 -c "import websocket;print(\"websocket-client ok\")" 2>&1; curl -sS -m 10 --cacert ~/.local/share/keplerops/ca.crt https://assistant.keplerops.test/api/ping; echo; timeout 20 pip download --no-deps -d /tmp/pipchk websockets 2>&1 | tail -3' 2>&1 | grep -v Warning | head -30
