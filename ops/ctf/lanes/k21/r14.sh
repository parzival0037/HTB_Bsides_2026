set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
J=/tmp/idx.js
echo "### ctx stream-chat"; grep -oE '.{600}/workspace/[^`]*stream-chat.{400}' $J | head -3
echo; echo "### agent ws"; grep -oE '.{300}agentInitWebsocketConnection.{300}' $J | head -3
echo; echo "### agent-invoke"; grep -oE '.{200}(agent-invocation|agentInvocation|AgentWebsocket|agent-websocket).{300}' $J | head -5
INNER
echo DONE_MARK_$RANDOM
