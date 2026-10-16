# 01 · Setup: hypervisor, network, and VMs

## Checklist

- [ ] Free disk space confirmed (150 GB recommended): ______
- [ ] VMware Workstation Pro installed
- [ ] Isolated network created (host-only / custom VMnet)
- [ ] Kali VM imported
- [ ] Windows 10/11 evaluation VM installed
- [ ] Wazuh OVA imported and booted
- [ ] Snapshot taken of every VM (`clean-install`)

## Network design

Use a **host-only** virtual network so the lab can't reach your home network or the internet unless you deliberately add a NAT adapter for updates.

| VM | IP (static) | Network |
|---|---|---|
| Wazuh | `192.168.56.10` | host-only |
| Windows victim | `192.168.56.20` | host-only |
| Kali | `192.168.56.30` | host-only |

> Adjust the subnet to match your VMnet settings.

## Notes while building

_Record what you did, what broke, and how you fixed it._

## Screenshots

Save to `../screenshots/01-setup/`.
