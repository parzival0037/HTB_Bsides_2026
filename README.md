# BSides CTF 2026 — "Operation NORTHSTORM" — team MoTM

Write-up and infrastructure analysis of the BSides CTF 2026 event
(`bsides.keplerops.com/ctf`), team **MoTM**.

**Final board: 91 / 240 challenges, 10,700 points.**

| Category | Solved | Total |
|---|---|---|
| 1. Training | 16 | 16 |
| 2. KeplerOps | 64 | 104 |
| 3. ARWC | 11 | 120 |

## Contents

| Doc | What's in it |
|---|---|
| [`docs/01-ctf-composition.md`](docs/01-ctf-composition.md) | What the event was made of: categories, difficulty curve, scoring, attempt model |
| [`docs/02-network-topology.md`](docs/02-network-topology.md) | Full network map with diagram: three segments, every host and service |
| [`docs/03-solved-challenges.md`](docs/03-solved-challenges.md) | All 91 solves with points, difficulty, flag and technique |
| [`docs/04-accounts-and-hosts.md`](docs/04-accounts-and-hosts.md) | Users, identities, tenants and credentials recovered |
| [`docs/05-method-and-tooling.md`](docs/05-method-and-tooling.md) | How the work was actually driven: access path, pivot, automation, agent lanes |
| [`docs/06-caveats.md`](docs/06-caveats.md) | Attribution, hint penalties, unattributed flags, dead ends |

## Short version

The event is a three-act story. Two short training segments teach the mechanics
(web app bugs, git history, SCADA semantics), then a large enterprise estate
("KeplerOps") and a customer/OT estate ("ARWC" — a water utility) make up the
bulk. 240 challenges, `FLAG{16 hex}` format, lockout-style attempt limiting,
hint penalties of 10–30 points per hint.

The infrastructure is a flat routed lab: a Kali workstation at `10.77.40.10`,
four training services on `10.77.40.0/24`, a KeplerOps service fabric on
`10.77.50.11` / `10.77.51.0/24`, a developer workstation at `10.50.13.180`, and a
single customer relay host at `10.77.60.20`. All of it is reached through the
event's browser SSH terminal and one SSH hop.

See [`docs/02-network-topology.md`](docs/02-network-topology.md) for the diagram.
