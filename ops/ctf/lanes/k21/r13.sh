set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
J=/tmp/idx.js
echo "### stream-chat"; grep -oE '.{80}stream-chat.{120}' $J | head -5
echo "### agent-invocation"; grep -oE '.{60}agent-invocation.{160}' $J | head -5
echo "### agentInitWebsocket"; grep -oE '.{60}agentInitWebsocketConnection.{200}' $J | head -5
echo "### /workspace/ paths"; grep -oE '.{40}/workspace/.{80}' $J | head -20
echo "### api base"; grep -oE '.{40}baseURL.{80}' $J | head -5
echo "### Swapping"; grep -oE '.{200}Swapping over to agent.{80}' $J | head -3
echo "### mode: automatic"; grep -oE '.{60}automatic.{100}' $J | head -10
INNER
echo DONE_MARK_$RANDOM
