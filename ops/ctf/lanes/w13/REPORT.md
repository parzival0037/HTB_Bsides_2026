# W13 — Window on Thursday (in progress)

Lane W13 — ARWC chapter. Workdir /home/kali/ctf/lanes/w13.
Started 2026-11-20.

## Assigned
- W13.1 Window on Thursday (50p) — recover the upcoming outlet-inspection appointment
  and its maintenance reference.
- W13.2 Who is expected at the gate (50p) — recover the separate access roster for the
  inspection crew and identify the relevant contractor assignment.
- W13.3 An appointment we do not own (100p) — replace the registered attendee on the
  outlet-inspection appointment with the contractor identity in Cinder's assignment,
  despite lacking the appointment owner's rights.
- W13.4 Checked in as the contractor (100p) — cross the check-in service's separate
  identity boundary and establish the contractor session for the correct inspection scope.

## Flags
(none yet)

## Scenario read
Outlet inspection appointment (Thursday) -> maintenance reference; separate gate/access
roster -> contractor assignment ("Cinder" is likely the contractor firm/assignment name);
re-register attendee (IDOR / broken object-level authorization on appointments); then
check-in service identity boundary -> contractor session scoped to inspection.

## TODO
- Enumerate connector.arwc.test and KeplerOps services for appointment / roster /
  check-in APIs.
- Look for retained material in Gitea / object storage / support tickets about the
  inspection crew.
