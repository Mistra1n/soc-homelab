# 03 · Attack simulations

One write-up per attack, using [`../templates/attack-writeup.md`](../templates/attack-writeup.md).

| # | Attack | MITRE ATT&CK | Status |
|---|---|---|---|
| 01 | [Port scan (nmap)](01-nmap-scan.md) | T1046 · Network Service Discovery | ✅ done — no alert (gap documented) |
| 02 | [RDP brute force (Hydra)](02-rdp-brute-force.md) | T1110.001 · Password Guessing | ✅ done — caught by Wazuh's default rule `92657`, no tuning needed |
| 03 | Malicious file download *(stretch goal)* | T1105 · Ingress Tool Transfer | ⬜ |

**Rule:** lab network only, my own machines only.

Scope note (2026-10-24): trimmed from 6 planned attacks to 2-3. Two well-documented attacks, including one with a real detection gap and one with a working alert and a tuned rule, demonstrate the full workflow just as well as six would, and it's a scope that actually gets finished.

**Lesson — snapshot before *and* after, not just before.** The `win-victim` VM was reverted to its `clean-install` snapshot (taken before this attack) after the RDP brute force had already run and been partially analyzed in Wazuh. Reverting wiped that evidence, since the snapshot predates both the attack and the Wazuh events it produced. Going forward: take a fresh snapshot immediately *after* each attack's evidence is confirmed and screenshotted, before touching the VM again, not just a single "clean" baseline at the start.
