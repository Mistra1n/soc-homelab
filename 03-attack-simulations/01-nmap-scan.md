# Attack: Port scan (nmap)

**Date:** 2026-10-22
**MITRE ATT&CK:** T1046 · Network Service Discovery
**Attacker → Target:** `kali (192.168.56.30)` → `win-victim (192.168.56.20)`

## 1. Objective

Simulate the reconnaissance step an attacker takes after landing on a network: find out what's listening on the target before deciding how to attack it. This is usually the very first signal a SOC gets that something is happening, so it's a good first test of the pipeline end to end.

## 2. Commands run

```bash
# Full TCP SYN scan, all 65535 ports
nmap -sS -p- 192.168.56.20

# Service/version and OS detection
nmap -sV -A 192.168.56.20

# Targeted re-scan of common lab-relevant ports, no host discovery ping
nmap -sS -p 135,139,445,3389 -Pn 192.168.56.20
```

## 3. What the logs showed

- Source: Wazuh / Sysmon (`win-victim`), checked in Threat Hunting → Events
- Result: **nothing**. Every scanned port came back `filtered (no-response)` — Windows Defender Firewall silently dropped the probes instead of replying. `nmap -sV -A` couldn't even fingerprint the OS ("Too many fingerprints match this host").
- Confirmed with a direct time check: the newest event before the scan was at `08:17:22`, and the scan ran at `08:29` (confirmed from Kali's `nmap` timestamp, corrected for timezone — see note below). The next Wazuh event after the gap was at `08:51:47`. A 36-minute window with **zero events** spans the entire scan.
- Screenshot: `../screenshots/03-attack-simulations/wazuh-events-after-scan-gap.png`

**Timezone note:** Kali's clock was set to US Eastern (`-0400`) by default from the pre-built image, which made the first timestamp comparison look wrong. Fixed with `sudo timedatectl set-timezone Africa/Nairobi` so future evidence timestamps line up directly with the Wazuh server (UTC) and screenshots without manual conversion.

## 4. Detection rule

None exists yet. This is the gap this write-up documents (see §5–6).

## 5. Did it alert?

- [ ] Yes, first time
- [ ] Yes, after tuning
- [x] No (gap noted below)

## 6. False positives and tuning

This isn't a tuning problem — it's a visibility gap. Sysmon and the Wazuh agent log activity **on the host** (processes, file writes, registry, host-level network connections made by processes). A SYN scan against closed/filtered ports never completes a connection and never touches a process on the victim, so there's nothing for Sysmon to see. Catching this kind of scan needs a different data source:

- **Network-layer IDS** (Suricata or Zeek) watching the VMnet2 segment, which Wazuh can ingest.
- Or, on the victim itself, **Windows Firewall logging** (`fw.log`) turned on and shipped as a Wazuh log source, which at least records "blocked inbound connection" events even without a full IDS.

This is now a concrete next step for the lab rather than a dead end: add Windows Firewall log collection (cheap, no new VM) and/or Suricata on the network segment (more realistic, more setup) and re-run this exact scan to confirm detection.

## 7. Lessons learned

- A silent, fully-blocked port scan is realistic and also realistically invisible to a host-based agent alone — this is a genuine and common SOC blind spot, not a lab mistake.
- Always check attacker and defender clocks match (or are both known and converted) before trusting a "no alert" result — a timezone mismatch looks identical to a missed detection until you check it.
- Next step: add a log source that can see unanswered connection attempts (firewall log or network IDS), then re-test.
