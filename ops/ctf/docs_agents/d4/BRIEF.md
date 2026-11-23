You are writing ONE markdown document for a GitHub CTF write-up repo at /tmp/htb_repo/docs/. 
STRICT RULES:
- Only state facts that appear in the source files listed below. Never invent hosts, ports, credentials, techniques, or challenge outcomes.
- If something is unknown, say "not recorded" rather than guessing.
- No personal data about real people. No leaderboard names. This is about infrastructure and technique only.
- GitHub-flavoured markdown: headings, tables, fenced code blocks, and ```mermaid diagrams where a picture helps.
- Write the file with the write tool. Keep it dense and readable, 80-160 lines.
SOURCES (read these first): /home/kali/ctf/lanes/NETMAP.md, /home/kali/ctf/ARWC-FINDINGS.md, /home/kali/ctf/FLAGS.md, /home/kali/ctf/HANDOVER.md, and the lane reports under /home/kali/ctf/lanes/*/REPORT.md.

TASK: write /tmp/htb_repo/docs/04-accounts-and-hosts.md
Cover: every account/identity recovered (OS users, service accounts, web app users, tenants, assets, Kerberos principals), where each was found, what it was valid for, and a credentials table. Group as: OS/workstation accounts, KeplerOps app accounts, service tokens, database roles, PKI/Kerberos identities, ARWC tenants/assets. Redact nothing from the CTF but mark each as "range-only, environment destroyed".