# 02 · Logging

Goal: the SIEM receives logins, process creations, and network events from both endpoints.

## Windows victim

1. Install **Sysmon** with a community config (see `../scripts/install-sysmon.ps1`).
2. Install the **Wazuh agent** and point it at the SIEM (see `../scripts/install-wazuh-agent.ps1`).
3. Make the agent forward the Sysmon channel (see `ossec-sysmon-snippet.xml`).

## Linux (Kali)

- Make sure `auth.log` / `journald` is being written.
- Install the Wazuh agent for Linux and register it.

## Verification checklist

- [ ] Agent shows **Active** in the Wazuh dashboard
- [ ] Sysmon Event ID 1 (process creation) appears
- [ ] Windows logon events (4624 / 4625) appear
- [ ] Linux SSH login events appear

## Notes and screenshots

Save evidence to `../screenshots/02-logging/`.
