# Per-challenge write-ups

One document per solved card: what the vulnerability was, the tools used, and the full
path from recon to flag. Each file opens with an **At a glance** table so you can see the
bug class before reading the walkthrough.

## Two kinds of file

Most files are **reconstructions**: they explain the bug class and the technique, and where
the exact transcript was not captured they say so. A few are **verbatim**: written from the
commands actually run, with the output as it appeared, up to the accepted flag — these end
in `_actual`:

- [K13.4](K13.4_actual.md)
- [K14.1](K14.1_actual.md)
- [K14.2](K14.2_actual.md)
- [K16.1](K16.1_actual.md)
- [K16.2](K16.2_actual.md)
- [K19.1](K19.1_actual.md)
- [K19.2](K19.2_actual.md)
- [K19.3](K19.3_actual.md)
- [T01.4](T01.4_actual.md)

The five new entries are the opencode/OC session's own solves: K13.4 (workload scope),
K14.1/K14.2 (trust and role records), K16.1/K16.2 (schedule disclosure and startup edit).
They include the accepted flag values and the live response bodies.

Both are worth reading. The reconstruction teaches the pattern; the `_actual` file shows what
it looks like when a real response comes back — including the wrong turns and the one
mis-attributed submission in K19.3.

## 1. Training

| Card | Title | Pts | Diff | Bug class | Solved by |
|---|---|---|---|---|---|
| [T01.1](T01.1.md) | The copy nobody deleted | 50 | easy | Secret retained in version-control history — content "deleted" from the working tree is still an addressable git blob in an older commit | team agent |
| [T01.2](T01.2.md) | Off the menu | 50 | easy | Unlinked-but-served content — the desk's navigation ("menu") lists fewer items than the service publishes; retired entries stay reachable by direct request | team agent |
| [T01.3](T01.3.md) | A token with a job | 50 | easy | Long-lived bearer credential published in a "retired client" profile; scope declared as `manifest:DL-204:read` but reusable by anyone who reads the file | team agent |
| [T01.4] ⭐(T01.4.md) | The helper has another job | 50 | easy | — | me (manual) |
| [T02.1](T02.1.md) | An account by any other response | 50 | easy | Account enumeration through a detailed recovery API — the lookup separates *active*, *gone* and *unknown* handles by status and body, and the active branch returns the account-bound case reference | me (manual) |
| [T02.2](T02.2.md) | Hidden on the page | 50 | easy | Client-side-only filtering plus a forgotten authorization on a sub-resource — the directory UI hides rehearsal entries, the API does not, and the per-staff detail route skips its check | me (manual) |
| [T02.3](T02.3.md) | Recovery is another way in | 50 | easy | Weak recovery proof — the takeover flow accepts knowledge the desk itself discloses (handle + case fragment + staff detail), so recon output becomes an authenticated session | me (manual) |
| [T02.4](T02.4.md) | Someone else's assignment | 100 | medium | IDOR / missing object-level authorization — the brief route authenticates the session but never checks that the assignment belongs to the caller | me (manual) |
| [T03.1](T03.1.md) | Deleted from the checkout | 50 | easy | Recoverable deletion — a fixture removed from the working tree but still present in version-control history, which the served checkout exposes | me (manual) |
| [T03.2](T03.2.md) | Verbose enough to publish | 50 | easy | Information disclosure through over-verbose published artefacts — build/publish output, metadata or source attached to a release that still contains material meant to stay internal | team agent |
| [T03.3](T03.3.md) | What installation really runs | 50 | easy | Install-time code execution in a package — a hook (`setup.py`, `postinstall`, install script) that runs with the installer's privileges and touches data the package never needed | me (manual) |
| [T03.4](T03.4.md) | A release they will consume | 100 | medium | Unsigned/unauthorised plugin in a consumer's formatter slot — a package that satisfies the documented interface is trusted to shape the consumer's delivery report, so supplying one lets you write into the report yourself | me (manual) |
| [T04.1](T04.1.md) | Which value is real | 50 | easy | Ambiguous process data — a *requested* setpoint reported next to the *measured* value, where only the measurement is evidence; the sealed record is keyed on the real number | me (manual) |
| [T04.2](T04.2.md) | The light behind the number | 50 | easy | Opaque packed status word — a fault condition encoded as one bit among many, behind a single integer that an operator reads as "ready" | me (manual) |
| [T04.3](T04.3.md) | A request is not a movement | 100 | medium | Accepted ≠ executed — an HTTP `202` is treated as proof of a physical transfer; the true effect is only visible in the device's observation stream | me (manual) |
| [T04.4](T04.4.md) | Yesterday's green light | 100 | medium | Stale, misattributed evidence — an earlier successful attempt's result is presented as the result of a later request that was rejected and moved nothing | me (manual) |

## 2. KeplerOps

| Card | Title | Pts | Diff | Bug class | Solved by |
|---|---|---|---|---|---|
| [K01.1](K01.1.md) | The developer left a way back | 50 | easy | Stale credential material on an endpoint — a long-lived personal access token in plaintext, reused across three services | team agent |
| [K01.2](K01.2.md) | The tab that survived | 50 | easy | Residual data in a browser profile — session restore, form history and SQLite state left on a shared workstation | team agent |
| [K01.3](K01.3.md) | Outside the working folder | 50 | easy | Orphaned copy — a protected artifact duplicated into a work-board record whose access control is weaker than the system of record | team agent |
| [K01.4](K01.4.md) | Put it on the workbench | 50 | easy | Client-supplied metadata trusted as fact — a helper that copies `asset_id`/`connector_revision` out of the uploaded sample instead of deriving them | team agent |
| [K02.1](K02.1.md) | The missing fixture | 50 | easy | Data still present in history after deletion — a "removed" test fixture recoverable from the git object store, plus a build log that retains the failure detail | pi lane K02 |
| [K02.2](K02.2.md) | An input outside its lane | 50 | easy | Leak through build artifacts — a retained review note exposes a token the job was never meant to publish | pi lane K02 |
| [K02.3](K02.3.md) | Green, with our changes | 100 | medium | Interface-only validation — the pipeline checks schema and shape, not whether the *assessment* is what the build produced | pi lane K09 |
| [K03.1](K03.1.md) | Our predecessor's desk | 100 | medium | Hidden payload in a retained document — a staging artifact carried inside a business document's container (embedded object, comment or encoded blob) | team agent |
| [K03.2](K03.2.md) | The script inside the script | 200 | hard | Nested payload — the recovered stage is a wrapper carrying a second, encoded stage plus its own instructions | team agent |
| [K03.3](K03.3.md) | Finish the callback | 200 | hard | Incomplete operator configuration — a half-configured callback plus a recovered key is enough to act as the collector and read the queued collection | team agent |
| [K04.1](K04.1.md) | A bundle with consequences | 200 | hard | Unsafe extraction / trusted bundle metadata — paths and object identities taken from the bundle itself | team agent |
| [K04.2](K04.2.md) | Read past the index | 400 | expert | Read primitive from the indexer's own extraction context — the bundle path that lets you write sideways also lets you read what the service can see | team agent |
| [K04.3](K04.3.md) | Control the allocation | 800 | expert | Write primitive under indexer restrictions — path-confused writes plus manifest-declared size/offset, giving a controlled write-what-where | team agent |
| [K04.4](K04.4.md) | The exception queue | 800 | expert | Write-to-execute — a file the service loads on start or on reindex turns a controlled write into code running as the indexer | team agent |
| [K05.1](K05.1.md) | Speak the package's language | 50 | easy | Interface conformance as an oracle — the documented example request is accepted verbatim and the check response discloses the answer | team agent |
| [K05.2](K05.2.md) | The version they kept | 50 | easy | Source-of-truth confusion — the release manifest, the channel slot and the retained customer record disagree, and the authoritative answer is the one the customer actually kept | team agent |
| [K06.1](K06.1.md) | House credentials | 100 | medium | Secret retained in VCS history — a publishing credential deleted from the working tree but still resolvable in earlier commits, with broader authority than its purpose | team agent |
| [K06.2](K06.2.md) | A private package in the wrong view | 100 | medium | Over-privileged CI identity — a build job holds a registry credential for a package developers cannot read, and the credential is recoverable from the job's own configuration or output | team agent |
| [K06.3](K06.3.md) | The rehearsal consumer | 100 | medium | Supply-chain code execution through a trusted package channel — a rehearsal service installs and runs a package published under a credential the attacker holds | team agent |
| [K07.3](K07.3.md) | The protected inspection | 400 | expert | Trusting attacker-supplied package framing — an inspection service executes a submitted package, and the inspector's restricted assessment is reachable by choosing the frame | team agent |
| [K08.1](K08.1.md) | The old entitlement | 100 | medium | Legacy protocol acceptance — a current service still honours an obsolete entitlement format, and an archived signed client can exercise it | team agent |
| [K09.1](K09.1.md) | A runner tells on itself | 50 | easy | Information disclosure via CI run metadata — the runner publishes its own record (profile, command, revision) to an API any authenticated user can read | team agent |
| [K09.2](K09.2.md) | The artifact without a link | 50 | easy | Orphaned retained artifact — the run record advertises artifacts the visible results page never links, and the artifact route serves them by name | team agent |
| [K09.3](K09.3.md) | A job input with reach | 100 | medium | Server-side reference resolution — a job carries a "linked support reference" that the render-review worker resolves and whose content is returned to the submitter | pi lane K09 |
| [K09.4](K09.4.md) | Run in the runner | 100 | medium | Command execution inside a CI worker, chained with a second service that trusts the worker's bearer token — job execution becomes impersonation | pi lane K09 |
| [K10.1](K10.1.md) | Whose preview is this | 100 | medium | Preview association leak — the renderer associates an arbitrary support attachment with a protected document identity and discloses which identity it believes it is presenting | me (manual) |
| [K10.2](K10.2.md) | Two inputs, one identity | 100 | medium | Identity collision in a normalising preview pipeline — two byte-different inputs normalise to the same document identity, so the viewer treats one as the other | team agent |
| [K10.3](K10.3.md) | The other document's contents | 200 | hard | Cross-document content substitution — a crafted support document resolves to a protected document identity, and the viewer renders the protected document's stored content | team agent |
| [K11.1](K11.1.md) | Where the policy begins | 100 | medium | Embedded policy program shipped to the client — the rules compiler carries its evaluation bytecode, so the decision logic is recoverable rather than opaque | team agent |
| [K11.2](K11.2.md) | Learn its instructions | 200 | hard | Published bytecode format with no assembler — the FKPC encoding is documented while the fragment programs are withheld, so the instruction set has to be recovered from the shipped binary | team agent |
| [K11.3](K11.3.md) | The rule behind the rule | 200 | hard | Undocumented policy constraints — the compiled acceptance program enforces conditions the published rules omit, so documented and actual behaviour diverge | team agent |
| [K12.1](K12.1.md) | The reviewer arrives second | 200 | hard | Review-state race / TOCTOU — the review binds to a document identity whose content can still change before the privileged reviewer opens it | team agent |
| [K12.2](K12.2.md) | A value across the action boundary | 400 | expert | Broken binding of a one-time/CSRF-style token — a protected value minted for one action is accepted by a separate privileged action | team agent |
| [K13.1](K13.1.md) | The listing nobody closed | 50 | easy | Anonymous object-storage listing — a workspace bucket allows unauthenticated `ListBucket`, exposing deployment notebooks that contain tokens | pi lane K13 |
| [K13.2](K13.2.md) | Before the correction | 50 | easy | Object versioning retains superseded content — the corrected notebook is the visible one, but the previous version is still retrievable and still holds what the correction removed | pi lane K13 |
| [K13.3](K13.3.md) | The export next door | 50 | easy | Cross-prefix object exposure — the same anonymously listable store holds tenant export records beside the notebooks | pi lane K13 |
| [K13.4](K13.4.md) | What the workload can do | 100 | medium | Over-scoped workload identity / RBAC reach — a workspace token exchanges into a Kubernetes service account that can read a ConfigMap holding another team's build token | pi lane K13 |
| [K14.1](K14.1.md) | The trust document | 50 | easy | Workload-identity trust material stored where the workload itself can read it — a self-authorising credential loop | pi lane K13 |
| [K14.2](K14.2.md) | Intended for someone else | 100 | medium | Over-broad token exchange — a workload JWT can be swapped for a role belonging to a *different* audience, and that role's record is returned | team agent |
| [K15.1](K15.1.md) | An export in progress | 50 | easy | Export job record readable through a delegated bearer with no per-job ownership check — the API authorises on the audience, not the requester | pi lane K15 |
| [K15.2](K15.2.md) | A job outside your account | 100 | medium | Missing object-level authorisation (IDOR) on a restricted sub-resource: the export *definition* is served to any holder of the export role, regardless of who created the job | pi lane K15 |
| [K16.1](K16.1.md) | Tomorrow's job | 50 | easy | Exposed scheduler object — a support CronJob's spec (command, image, identity, trigger) readable through the cloud API by a non-owner | team agent |
| [K16.2](K16.2.md) | The next startup | 100 | medium | Unauthorised modification of a scheduled workload's startup (command/args) — scheduler object writable by a non-owner, executed with the original service identity | team agent |
| [K17.1](K17.1.md) | A support session left behind | 50 | easy | Broken retention — a closed/withdrawn support session stays in the ticketing system, and the retention pointer (with the flag) is still stored in the thread | pi lane K25 |
| [K17.2](K17.2.md) | A different way to recover | 100 | medium | Multiple independent copies of one support artefact — the "deleted" session is still recoverable through a second surface (handover/export artefact) with weaker access control | team agent |
| [K17.3](K17.3.md) | Which customers belong here | 50 | easy | Tenant/partition metadata exposed to a low-privileged database role — which customers sit in an export partition is readable without touching customer data | team agent |
| [K18.1](K18.1.md) | The note behind the preview | 100 | medium | Preview/render path resolves a restricted note without re-checking its classification — the viewer renders content it was never authorised to show, and the association names the consuming identity workflow | team agent |
| [K19.1] ⭐(K19.1.md) | Who vouches for whom | 100 | medium | — | me (manual) |
| [K19.2] ⭐(K19.2.md) | Borrowed colleague | 200 | hard | — | me (manual) |
| [K19.3] ⭐(K19.3.md) | The archive delegates | 400 | expert | — | me (manual) |
| [K21.1](K21.1.md) | The policy beside the prompt | 50 | easy | Unauthenticated configuration disclosure — the assistant's `/api/config` exposes its system prompt, policy wiring and internal context/workspace identifiers | pi lane K21 |
| [K21.2](K21.2.md) | A conversation kept too long | 50 | easy | Retention failure in the assistant overlay — a conversation flagged `deleted_from_ui` is still served, and reading it needs only a support bearer in a cookie | pi lane K21 |
| [K21.3](K21.3.md) | The answer it should withhold | 100 | medium | Retrieval-citation disclosure — the document route returns the full source text an answer was built from, so the guardrail is bypassed by reading its evidence instead of its output | pi lane K21 |
| [K23.1](K23.1.md) | A context view left open | 50 | easy | Unauthenticated inventory endpoint — `/api/contexts` lists unpublished retrieval contexts, their conversations, documents and workspace bindings | pi lane K23 |
| [K23.2](K23.2.md) | The conversation reference | 50 | easy | Dangling cross-tenant reference — a retained selection in one customer's case points at another customer's conversation, and the conversation route serves it | pi lane K23 |
| [K23.3](K23.3.md) | A missing tenant boundary | 100 | medium | Cross-tenant object read on a RAG document route — the request validates the context/conversation pair but never the document's tenant | pi lane K23 |
| [K24.1](K24.1.md) | Complete the job | 50 | easy | Sensitive-data exposure through a "documentation" endpoint — a retained completion **example** is a copy of a live support job | pi lane K23 |
| [K27.1](K27.1.md) | A job for that customer | 100 | medium | Client-controlled tenant binding — a support account scoped to its own customers can open a diagnostic job for another tenant by naming an active connector revision | team agent |
| [K27.2](K27.2.md) | Our diagnostic, their interface | 100 | medium | Interface-only trust — a package is accepted on shape (`fieldkest.connector/v3`, one exported function) plus a caller-declared output, with no signature or provenance binding | team agent |
| [K27.3](K27.3.md) | The other side of support | 100 | medium | Trust-boundary crossing — the vendor's support workflow is a sanctioned channel into the customer's own connector, so a vendor-side action becomes code execution on the customer's estate | team agent |
| [K28.1](K28.1.md) | A connector with two faces | 100 | medium | Hidden behaviour behind a signed configuration switch — the same binary exposes an ordinary interface and a diagnostic loader that only activates for a specific signed setting | team agent |
| [K29.1](K29.1.md) | The build record's principal | 100 | medium | Over-broad capability — a limited "release-reader" principal accepted by a path test matching *any* `/artifacts/` URL rather than the record it was minted for | team agent |
| [K29.2](K29.2.md) | The signer in the history | 200 | hard | Secret retained in version-control history — signing material "removed" from the current tree but still fetchable at an older revision | team agent |
| [K29.4](K29.4.md) | After the old key expires | 400 | expert | Release-credential lifecycle gap — a delivery pipeline that verifies by exact key id rather than by lineage, so a rotation invalidates everything signed with the retired key | me (manual) |
| [K31.1](K31.1.md) | Whose maintenance job | 100 | medium | Identity confusion in delegated scheduling — a maintenance job's *policy* decision and its *runtime* execution are evaluated under different principals | team agent |

## 3. ARWC

| Card | Title | Pts | Diff | Bug class | Solved by |
|---|---|---|---|---|---|
| [W01.1](W01.1.md) | The customer's copy | 50 | easy | Broken tenant/copy isolation — the customer's retained handover is served by the *supplier's* support API behind one shared integration bearer, so "customer-owned" is a label rather than an access-control boundary | pi lane W01D |
| [W01.2](W01.2.md) | The planner's unfinished handover | 50 | easy | Over-shared external document folder — the customer's planning handover sits in a supplier-owned document folder reachable with one integration token, and the document's own identifiers are the only reliable correlation key | team agent |
| [W01.3](W01.3.md) | How the company buys time | 50 | easy | Retained-record disclosure — commercial records (shortfall contingency, supplementary-water purchase orders) kept in the shared customer document set and readable with a supplier integration credential | team agent |
| [W02.1](W02.1.md) | The asset and the contractor | 50 | easy | Cross-system identity disclosure — an inspection trace endpoint correlates an internal work order with supplier job metadata, exposing asset and contractor identifiers a delivery-only caller should not see | team agent |
| [W02.2](W02.2.md) | Three names for one job | 100 | medium | Correlation-graph disclosure — an inspection trace returns the internal work order, the supplier job and the engineering drawing for the same job, plus a flag, to a caller who only needed the public manifest result | team agent |
| [W03.1](W03.1.md) | An annex left with the order | 50 | easy | Retained annex disclosure with a version-pinned inspection oracle — the supplier order keeps the work-order annex, and the inspection trace reveals it (and a flag) only for the exact pinned revision | pi lane W03B |
| [W03.3](W03.3.md) | The integration's read contract | 100 | medium | Contract/implementation mismatch — the approved planning read service publishes more than its declared client contract, so the documented boundary is descriptive rather than enforced | team agent |
| [W13.1](W13.1.md) | Window on Thursday | 50 | easy | Object-level authorisation gap on a scheduling API — an outlet-inspection appointment is readable by identifier, and the appointment body includes the maintenance reference | team agent |
| [W14.1](W14.1.md) | The field bag | 50 | easy | Artifact retrieval authorised by run id only — a retained field export sits in the contractor review workspace, readable by anyone who knows (or derives) the run and artifact name | team agent |
| [W19.1](W19.1.md) | The diagnostic nobody retired | 100 | medium | Provenance confusion — a retained diagnostic package is filed under the customer's records but its embedded family/asset markers belong to a different project, so its behaviour is explained by the wrong plant model | team agent |
| [W31.1](W31.1.md) | The vault's misleading length | 100 | medium | Parser differential — a declared length does not describe the real record boundary, so the naive reader stops early and never reaches the record holding the protected diagnostic reference | team agent |

