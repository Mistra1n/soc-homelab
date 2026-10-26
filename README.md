# SOC Homelab

A hands-on Security Operations Center (SOC) lab built on a single laptop. An attacker VM generates real malicious traffic against a Windows victim, every event is shipped to a SIEM, and I write detection rules to catch the activity and map it to MITRE ATT&CK.

> **Status:** ✅ Core workflow complete — network built, telemetry flowing, two attacks simulated and detected (one by a custom rule). See the [progress tracker](#progress) below.

## Architecture

```
┌───────────────┐   attacks   ┌────────────────────┐   logs    ┌──────────────────┐
│  Kali Linux   │ ──────────► │  Windows 10/11     │ ────────► │  Wazuh SIEM      │
│  (attacker)   │             │  (victim + Sysmon) │           │  (server/indexer │
└───────────────┘             └────────────────────┘           │   + dashboard)   │
                                                               └──────────────────┘
                     Isolated host-only network (no internet exposure)
```

| Machine | Role | OS | RAM | Disk |
|---|---|---|---|---|
| `kali` | Attacker | Kali Linux | 2 GB | 30 GB |
| `win-victim` | Victim / log source | Windows 10 (21H1) + Sysmon + Wazuh agent | 4 GB | 50 GB |
| `wazuh` | SIEM | Wazuh 4.14.9 all-in-one OVA | 4 GB | 50 GB |

**Host:** MSI Crosshair 15 · Intel i7-11800H (8C/16T) · 20 GB RAM · Windows 11 Pro
**Hypervisor:** VMware Workstation Pro 17

## Goals

- Build an isolated, repeatable detection lab
- Collect endpoint telemetry (Sysmon, Windows Event Logs, Linux auth logs)
- Simulate common attacks and observe them in the SIEM
- Write and tune detection rules, mapped to MITRE ATT&CK
- Document each step like an incident write-up

## Progress

- [x] 01 · Hypervisor and isolated network
- [x] 02 · Core machines (Kali ✅ · Wazuh ✅ · Windows victim ✅, static IPs on all three)
- [x] 03 · Logging (Sysmon + Wazuh agent forwarding, verified in the SIEM)
- [x] 04 · Attack simulations (2 of 2 planned: port scan, RDP brute force — see scope note in [`03-attack-simulations/`](03-attack-simulations/))
- [x] 05 · Detection rules (custom rule `100001` deployed and verified, see [`04-detection-rules/`](04-detection-rules/))
- [x] 06 · Findings ([`05-findings/`](05-findings/))

### Status (2026-10-24)

The core loop is done end to end: three isolated VMs → Kali attacks the victim → Sysmon + Wazuh agent ship logs → Wazuh detects. Two attacks were simulated and documented:

- **Port scan (nmap):** no alert at all — a genuine visibility gap (host-based agents can't see a silently-filtered scan without a network IDS, which this lab doesn't have).
- **RDP brute force (Hydra):** caught twice — by Wazuh's built-in rule `92657` (success + pass-the-hash heuristic), and by a custom rule (`100001`) tuned to fire earlier, on the 5th failed attempt rather than waiting for a successful one.

Along the way: a VM snapshot revert erased one attack's evidence before it was written up, which became its own documented lesson about snapshot timing. Remaining work (Linux/Kali logging, more attacks, a dashboard) is optional polish, not required for the core project to stand on its own — see each folder's README for ideas if picking this back up.

## Repo layout

| Folder | Contents |
|---|---|
| [`01-setup/`](01-setup/) | Hypervisor, network design, VM builds |
| [`02-logging/`](02-logging/) | Sysmon config, agent installation, log verification |
| [`03-attack-simulations/`](03-attack-simulations/) | One write-up per simulated attack |
| [`04-detection-rules/`](04-detection-rules/) | Custom Wazuh rules and MITRE mapping |
| [`05-findings/`](05-findings/) | Incident-style reports |
| [`scripts/`](scripts/) | Helper scripts (PowerShell / Bash) |
| [`screenshots/`](screenshots/) | Evidence for each phase |
| [`templates/`](templates/) | Write-up templates |

## Ethics and safety

Every attack in this repo was run **only against machines I own, inside an isolated lab network**. Do not use these techniques against systems you don't own or have written permission to test.

## Tools

Wazuh · Sysmon · Kali Linux · nmap · Hydra · VMware Workstation · MITRE ATT&CK

## Other projects in this repo

| Project | What it is | Status |
|---|---|---|
| [`pfsense-kali-ubuntu-lab/`](pfsense-kali-ubuntu-lab/) | pfSense firewall between a Kali attacker and an Ubuntu/DVWA target — before/after evidence that firewall rules actually block attack traffic | 🚧 Planned |
| [`htb-ad-ldap/`](htb-ad-ldap/) | Write-up for HTB Academy's Active Directory LDAP module — AD fundamentals, LDAP search filters, enumeration, skills assessment | 🚧 In progress |
