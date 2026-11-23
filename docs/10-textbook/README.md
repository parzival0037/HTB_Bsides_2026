# A textbook built from one CTF range

Eleven chapters, each about **one class of bug**. Every chapter follows the same shape so
you can read them in any order once you have done Part I:

> what it is → **why it exists** (the developer's wrong assumption) → how to spot it →
> how to test it → a case study from this range → variations → how to fix it → exercises

The case studies are real requests against real services, taken from the
[per-challenge write-ups](../../writeups/). They are cited by card code, so you can jump
from theory to a worked example and back.

---

## Where to start

| You are… | Do this |
|---|---|
| completely new | [`../00-start-here.md`](../00-start-here.md) — the loop, curl/git/jq, and a full worked desk |
| ready to practise | [`../20-labs.md`](../20-labs.md) — build each bug locally, break it, fix it |
| comfortable with HTTP | chapters 01 → 02 → 03 in order, then pick by interest |
| here for a specific bug | the table below, then the matching write-ups |

---

## The chapters

### Part II — Foundations of looking

| # | Chapter | You will learn | Case studies |
|---|---|---|---|
| 01 | [Reading a target](01-reading-and-recon.md) | status codes, lengths and headers as data; reading page source and JS; the "unintended observability" frame | T01.2, T02.1, K01.3 |

### Part III — Access control and data

| # | Chapter | You will learn | Case studies |
|---|---|---|---|
| 02 | [Access control](02-access-control.md) | authentication vs authorisation, IDOR, missing ownership checks, tenant isolation, role confusion | T02.4, K14.2, K15.2, K25.2 |
| 03 | [Paths and files](03-paths-and-files.md) | path traversal, why prefix checks fail, canonicalisation, file-parameter shapes | T01.4 |
| 04 | [Secrets and config](04-secrets-and-config.md) | where credentials hide, reading scope, chaining a leaked token | K01.1, T01.3, K05.1 |
| 05 | [Git and artifacts](05-git-and-artifacts.md) | history as a data source, deleted files, CI artifacts, run directories | T01.1, T03.1, K02.1, K09.2 |

### Part IV — Identity, crypto and supply chain

| # | Chapter | You will learn | Case studies |
|---|---|---|---|
| 06 | [Supply chain](06-supply-chain.md) | package metadata, dist-tags, install hooks, provider contracts, signing | T03.3, T03.4, K02.3, K05.2, K29.x |
| 07 | [Crypto and PKI](07-crypto-and-pki.md) | mTLS, what a client cert actually asserts, EKU, issuance policy vs subject binding, sealed records | K19.1, K19.2, T04.1 |
| 08 | [Identity and delegation](08-identity-and-delegation.md) | Kerberos SPN/ccache/delegation, OIDC tokens, audience-scoped exchange | K19.3, K13.x, K15.1 |
| 09 | [Cloud and containers](09-cloud-and-containers.md) | k8s service accounts, RBAC reality, token exchange, object-storage scoping, job abuse | K13.4, K14.1, K24.1 |

### Part V — Modern and industrial surfaces

| # | Chapter | You will learn | Case studies |
|---|---|---|---|
| 10 | [LLM applications](10-llm-applications.md) | workspace prompts, retrieval contexts, retained conversations, cross-tenant context, injection that becomes action | K21.x, K22.x, K23.x |
| 11 | [OT and SCADA](11-ot-and-scada.md) | registers and units, measurement vs setpoint, status words, permissives, bounded actuation, historian correlation | T04.x, W17.x, W19.x |

---

## How to actually learn from a chapter

Reading a chapter once teaches you the vocabulary. That is not the skill. The skill is
prediction.

1. Read the case study and **stop before the exploit step**.
2. Write down what you think the next request returns, and why.
3. Run it (or read on) and compare.
4. If you were wrong, the gap is the lesson — write one sentence about what you assumed.

Do that for four or five cards in a row and you will start predicting *before* you finish
reading the challenge description. That is what "being able to solve CTFs" feels like from
the inside.

## A note on scope

All of this is defensive knowledge applied to a lab built for it. The same techniques on a
system you do not own or have written permission to test is a crime in most jurisdictions,
and the bug classes here are exactly the ones that show up in real breach reports — which
is why the "how to fix it" section matters as much as the "how to break it" one.
