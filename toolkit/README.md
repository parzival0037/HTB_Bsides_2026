# Toolkit

The scripts that drove the run. They target a range that no longer exists, so treat them as
the *shape* of an automated CTF workflow rather than something you can point at a live host.

```bash
./box.py 'id'                       # run a command on the range box over the WS terminal
./box.py -f script.sh               # upload and run a batched script
./submit.py 'K19.2' 'FLAG{...}'     # submit a flag by card prefix
./brief.py '^W17'                   # unsolved cards with descriptions + unlocked hints
python3 kanban.py                   # rebuild the board
python3 claims.py                   # publish what is being worked on
./fleet.sh queue.txt 3 4            # at most 3 lanes, 4 retries, adaptive backoff
```

Two habits worth copying from this toolkit regardless of the CTF:

1. **Batch remote work.** Every `box.py` call is a fresh shell; state does not persist, so a
   single upload+run script beats ten round trips.
2. **Publish claims.** When several agents share one target, a claim file prevents two of
   them burning attempts on the same card.

`hints.py` is deliberately hard-disabled: hints cost score permanently.
