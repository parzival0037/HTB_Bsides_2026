# Lane K24 — Complete the job / Context with a credential / The completion runs

Status: IN PROGRESS (started 18:20Z)

## Target
K24 is about the KeplerOps **support assistant** at `https://assistant.keplerops.test`
(Express app, "Browser application, conversation, answer, and completion operations").
Reachable from range box through SOCKS5 pivot 127.0.0.1:1080.

Client reference (`/.well-known/fieldkest-client`) routes seen so far:
- assistant.app            GET  /static/app.js
- assistant.config         GET  /api/config
- assistant.contexts       GET  /api/contexts
- assistant.conversation   GET  /api/conversations/{conversation_id}
- assistant.selection      GET  /api/selections/{selection_id}
- assistant.document       GET  /api/contexts/{context_id}/conversations/{conversation_id}/documents/{document_id}
- assistant.answers        POST /api/answers
- assistant.completion-example  GET  /api/completions/examples/{example_id}
- assistant.completion-context  POST /api/completions/context
- (more truncated — re-fetch)

## Findings / flags
(none yet)

## Dead ends
- Gitea repos (connector-archive, fieldlink-connector, policy-compiler, release-signer-history) — no "completion" hits so far.
- /tmp UUID files on range box are CRLite cert intermediates, unrelated.
