LANE: T04 — outlet / SCADA desk.
Target: http://state.training:8080/ (10.77.40.50) plus its services/APIs.

Challenges:
- T04.1 "Which value is real": read the supplied training-tank observation and work out
  how much water it actually contains — separate the measurement from the requested or
  setpoint level (register/word interpretation, scaling, engineering units).
- T04.2 "The light behind the number": decode the supplied controller status capture
  and identify the condition preventing the practice outlet from moving (a bit/flag in
  a status word).
- T04.3 "A request is not a movement": move the specified bounded amount of water
  through the training outlet, then verify the transfer from the tank's observations.
  Respect the stated bounds; verify before and after.
- T04.4 "Yesterday's green light": the report claims the latest outlet test succeeded
  but the observations disagree — reconstruct what actually happened from the evidence
  (timestamps, logs, values) and explain the discrepancy.

This desk models physical process control. One attempt was already burned on T04.4.
Never guess a flag; establish the value from the evidence.
