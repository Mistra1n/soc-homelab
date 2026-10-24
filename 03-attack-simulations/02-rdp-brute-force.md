# Attack: RDP brute force (Hydra)

**Date:** 2026-10-24
**MITRE ATT&CK:** T1110.001 · Brute Force: Password Guessing
**Attacker → Target:** `kali (192.168.56.30)` → `win-victim (192.168.56.20)`

## 1. Objective

Simulate an attacker who has found an open RDP service (port 3389) and tries a short list of common passwords against a known or guessed username. Unlike the port scan in attack 01, this attack actually completes a connection and authenticates, so it should be visible to a host-based agent like Wazuh — this is the test of whether the logging pipeline catches something that actually happens on the host, not just something that arrives on the wire.

## 2. Setup notes

- `win-victim`'s RDP requirement for Network Level Authentication (NLA) was disabled (`sysdm.cpl` → Remote tab) because Hydra's RDP module cannot complete the NLA handshake. This is a lab concession to test the module — a real target would more likely have NLA on, which is itself a mitigation worth noting (§7).
- First run of this attack (2026-10-22) succeeded and was partially visible in Wazuh, but the evidence was lost when `win-victim` was reverted to its `clean-install` snapshot before the write-up was saved — see the lesson in [`README.md`](README.md). This write-up is from the re-run on 2026-10-24.
- On this re-run, the Wazuh agent needed a manual `Restart-Service WazuhSvc` after the earlier VM/host reboot before it resumed forwarding events — it was `Running` but not actively shipping logs until restarted.

## 3. Commands run

```bash
echo "dev" > /tmp/users.txt
echo -e "password\nPassword1\n123456\nAdmin123\nqwerty\n6" > /tmp/passwords.txt
hydra -t 1 -W 1 -L /tmp/users.txt -P /tmp/passwords.txt rdp://192.168.56.20
```

Result: 5 wrong passwords tried, then the 6th (`6`, the real local password, included deliberately to prove detection on both failure and success) succeeded — `1 of 1 target successfully completed, 1 valid password found`.

## 4. What the logs showed

Source: Wazuh / Windows Security log (`win-victim`), Threat Hunting → Events, `agent.name: win-victim`, 22:40–22:55 window. 73 hits total; the attack sequence:

| Time | Rule ID | Level | Description |
|---|---|---|---|
| 22:50:56 – 22:50:58+ | `60122` | 5 | Logon Failure - Unknown user or bad password (×5, one per wrong password) |
| 22:51:00 | `92657` | **6** | **Successful Remote Logon Detected - User:\Dev - NTLM authentication, possible pass-the-hash attack - Possible RDP connection** |
| 22:51:00 | `67028` | 3 | Special privileges assigned to new logon (×2) |
| 22:51:00 | `60137` | 3 | Windows User Logoff |

Screenshot: `../screenshots/03-attack-simulations/wazuh-rdp-brute-force-events.png`

## 5. Detection rule

Wazuh's **default, built-in rule `92657`** already caught the successful logon and correctly flagged it as a possible RDP brute-force / pass-the-hash pattern — no custom rule was required for this to alert. The repeated `60122` failures immediately before it are the supporting evidence of the brute-force attempt itself.

A custom aggregate rule also exists for this pattern, in [`../04-detection-rules/local_rules.xml`](../04-detection-rules/local_rules.xml) — rule `100001`, which fires on 5+ failed logons (`if_matched_sid 60122`) within a 2-minute window, mapped to T1110. This is a tuning exercise on top of the default coverage: it collapses the five individual `60122` failures into a single higher-confidence alert before the successful logon even happens, which is earlier warning than waiting for `92657`.

## 6. Did it alert?

- [x] Yes, first time (default Wazuh rule `92657`, no tuning needed)

## 7. False positives and tuning

- `92657`'s own description already hedges ("possible pass-the-hash attack... Verify t...") — it's a heuristic, not a certainty, since NTLM successful-logon-after-failures can also be a legitimate user who mistyped their password a few times. In a real SOC this would be triaged against source IP reputation and whether the source is an expected admin workstation.
- The custom rule `100001` adds a clearer, purpose-built signal (count-based, not heuristic) and triggers before a password is actually guessed correctly, which is the more useful early-warning point for a defender.

## 8. Lessons learned

- A completed authentication (even a failed one) is visible to a host-based agent, unlike the silent port scan in attack 01 — the contrast between the two attacks is a good demonstration of what host-based vs. network-based detection each can and can't see.
- Wazuh's default ruleset already has meaningful brute-force/pass-the-hash coverage out of the box; custom rules are for tuning and earlier detection, not starting from zero.
- Disabling NLA to make the attack tool work is a reasonable lab trade-off, but it's also a finding in itself: NLA is a real mitigation against this exact attack, since it requires authentication before the full RDP session (and this Hydra module) can even negotiate.
- Snapshot discipline matters: this attack had to be re-run because evidence from the first run was lost to a revert taken before the attack, not after.
