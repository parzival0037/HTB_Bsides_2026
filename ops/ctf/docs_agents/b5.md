You are writing ONE markdown document for a GitHub CTF write-up repo at /tmp/htb_repo/docs/. 
STRICT RULES:
- Only state facts that appear in the source files listed below. Never invent hosts, ports, credentials, techniques, or challenge outcomes.
- If something is unknown, say "not recorded" rather than guessing.
- No personal data about real people. No leaderboard names. This is about infrastructure and technique only.
- GitHub-flavoured markdown: headings, tables, fenced code blocks, and ```mermaid diagrams where a picture helps.
- Write the file with the write tool. Keep it dense and readable, 80-160 lines.
SOURCES (read these first): /home/kali/ctf/lanes/NETMAP.md, /home/kali/ctf/ARWC-FINDINGS.md, /home/kali/ctf/FLAGS.md, /home/kali/ctf/HANDOVER.md, and the lane reports under /home/kali/ctf/lanes/*/REPORT.md.

TASK: write /tmp/htb_repo/docs/05-method-and-tooling.md
Cover: how the run was driven and the technique catalogue. Include: browser-terminal WebSocket access + box.py driver; the rowan-dev pivot constraint (AllowTcpForwarding local + PermitOpen 127.0.0.1:13389) and the SOCKS5 relay + -L solution, with the mermaid diagram; the fleet/agent model (headless pi lanes, claims, kanban); and a techniques table mapping technique -> example cards. Techniques seen: path traversal, user enumeration by response diff, recovery-flow takeover, IDOR, git history recovery, install-hook analysis, provider package build, SCADA register/status decode, bounded actuation + observation verification, log-vs-report reconciliation, credential harvesting from dotfiles, browser profile recovery, client-cert enrollment via /api/enrollment/..., mTLS archive access, Kerberos delegation probe, AnythingLLM context/prompt leaks, Jenkins runner source leak, k8s/workspace token exchange.