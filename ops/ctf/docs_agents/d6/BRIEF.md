You are writing ONE markdown document for a GitHub CTF write-up repo at /tmp/htb_repo/docs/. 
STRICT RULES:
- Only state facts that appear in the source files listed below. Never invent hosts, ports, credentials, techniques, or challenge outcomes.
- If something is unknown, say "not recorded" rather than guessing.
- No personal data about real people. No leaderboard names. This is about infrastructure and technique only.
- GitHub-flavoured markdown: headings, tables, fenced code blocks, and ```mermaid diagrams where a picture helps.
- Write the file with the write tool. Keep it dense and readable, 80-160 lines.
SOURCES (read these first): /home/kali/ctf/lanes/NETMAP.md, /home/kali/ctf/ARWC-FINDINGS.md, /home/kali/ctf/FLAGS.md, /home/kali/ctf/HANDOVER.md, and the lane reports under /home/kali/ctf/lanes/*/REPORT.md.

TASK: write /tmp/htb_repo/docs/06-caveats.md
Cover honestly: attribution split (manual vs headless lanes vs another agent on the team), hint spend (42 hints / 770 points forfeited, and which cards), the wrong-attempt count (~426) and why guessing is bad, two flags that were found but never attributed (FLAG{d58c860051957082} from support diagnostics create; FLAG{870a03c573511895} from legacy package deprecation record), hard dead ends (ARWC relay channel identity; sshd PermitOpen; rowan-dev /tmp 64MB tmpfs full; kubernetes SA has no resource perms), and what a future run should do differently.