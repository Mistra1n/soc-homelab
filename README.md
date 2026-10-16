# SOC Homelab

A hands-on Security Operations Center (SOC) lab built on a single laptop. An attacker VM generates real malicious traffic against a Windows victim, every event is shipped to a SIEM, and I write detection rules to catch the activity and map it to MITRE ATT&CK.

> **Status:** 🚧 In progress. See the [progress tracker](#progress) below.

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
| `win-victim` | Victim / log source | Windows 10/11 + Sysmon + Wazuh agent | 4 GB | 50 GB |
| `wazuh` | SIEM | Wazuh all-in-one OVA | 5 GB | 50 GB |

**Host:** MSI Crosshair 15 · Intel i7-11800H (8C/16T) · 20 GB RAM · Windows 11 Pro
**Hypervisor:** VMware Workstation Pro

## Goals

- Build an isolated, repeatable detection lab
- Collect endpoint telemetry (Sysmon, Windows Event Logs, Linux auth logs)
- Simulate common attacks and observe them in the SIEM
- Write and tune detection rules, mapped to MITRE ATT&CK
- Document each step like an incident write-up

## Progress

- [ ] 01 · Hypervisor and isolated network
- [ ] 02 · Core machines (Kali, Windows victim, Wazuh server)
- [ ] 03 · Logging (Sysmon + Wazuh agent, Linux auth logs)
- [ ] 04 · Attack simulations
- [ ] 05 · Detection rules and dashboard
- [ ] 06 · Findings and lessons learned

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
