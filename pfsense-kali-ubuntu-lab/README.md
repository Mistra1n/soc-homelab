# pfSense Perimeter Lab — Kali → pfSense → Ubuntu/DVWA

A small, focused lab that puts a pfSense firewall between an attacker (Kali) and a vulnerable web server (Ubuntu + DVWA), to prove — with before/after evidence — that firewall rules actually stop attack traffic that otherwise succeeds.

> **Status:** 🚧 Planned — see [progress](#progress) below.

## Architecture

```
┌───────────────┐   attack traffic    ┌──────────────────┐   allowed only    ┌──────────────────┐
│  Kali Linux   │ ───────────────────►│   pfSense CE      │───────────────────►│  Ubuntu Server   │
│  (attacker)   │   X blocked by      │   (firewall/      │   (HTTP responses  │  Apache+PHP+MySQL│
│               │◄─── ruleset         │    router)        │◄─── only)          │  + DVWA           │
└───────────────┘                     └──────────────────┘                    └──────────────────┘
                WAN-side (Kali)                                    LAN-side (Ubuntu)
                 isolated host-only / internal virtual networks only, no bridge to the internet
```

| Machine | Role | OS | RAM | Disk |
|---|---|---|---|---|
| `kali` | Attacker | Kali Linux | 2 GB | 20 GB |
| `pfsense` | Firewall / router | pfSense CE (latest) | 1–2 GB | 8–20 GB |
| `ubuntu-dvwa` | Victim / web target | Ubuntu Server 22.04 + Apache/PHP/MySQL + DVWA | 2 GB | 20 GB |

**Hypervisor:** VirtualBox

## Goals

- Build a 3-VM topology with pfSense as the chokepoint between attacker and target
- Prove the "before" state: attacks succeed with no firewall rules in place
- Write pfSense firewall rules that block the attack while still allowing legitimate web traffic
- Prove the "after" state: same attacks fail, pfSense logs show the blocks
- Document it as a before/after case study, not just a setup guide

## Progress

- [ ] 01 · VirtualBox networks + VM shells created (pfSense, Kali, Ubuntu)
- [ ] 02 · pfSense installed and routing between the two networks
- [ ] 03 · Ubuntu + DVWA deployed and reachable from Kali
- [ ] 04 · Baseline attack run with no firewall rules (nmap scan + DVWA exploit) — "before" evidence
- [ ] 05 · Firewall rules written and applied
- [ ] 06 · Same attacks re-run — "after" evidence, confirmed blocked in pfSense logs
- [ ] 07 · Findings write-up

## Repo layout

| Folder | Contents |
|---|---|
| [`01-setup/`](01-setup/) | VirtualBox network design, VM creation, pfSense base install |
| [`02-firewall-config/`](02-firewall-config/) | Interface config, DHCP, the actual firewall rules and why |
| [`03-attack-simulations/`](03-attack-simulations/) | One write-up per attack, each with a before/after section |
| [`04-findings/`](04-findings/) | Summary report: what was blocked, what wasn't, lessons learned |
| [`screenshots/`](screenshots/) | Evidence — topology, pfSense rules, attack output, logs |

## Ethics and safety

Every attack in this repo was run **only against machines I own, inside an isolated lab network with no bridge to the internet**. Do not use these techniques against systems you don't own or have written permission to test.

## Tools

pfSense CE · Kali Linux · Ubuntu Server · DVWA · nmap · VirtualBox
