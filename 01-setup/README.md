# 01 · Setup: hypervisor, network, and VMs

## Status

- [x] Free disk space confirmed (~100 GB on C:)
- [x] VMware Workstation Pro 17 installed
- [x] Isolated host-only network created (`VMnet2`, `192.168.56.0/24`, DHCP off)
- [x] Kali VM imported (official VMware pre-built image, 2026.2)
- [x] Wazuh server imported (OVA 4.14.9), boots to login, `clean-import` snapshot taken
- [x] Windows 10 21H1 ISO downloaded (5.7 GB)
- [ ] Windows victim VM created
- [ ] Static IPs set on all three VMs
- [ ] `clean-import` snapshot of Kali and the Windows victim

## Host

| | |
|---|---|
| Machine | MSI Crosshair 15 (i7-11800H, 8C/16T) |
| RAM | 20 GB (about 9 GB in use at idle, so VMs are booted one at a time at first) |
| OS | Windows 11 Pro, virtualization-based security on |
| Hypervisor | VMware Workstation Pro 17 |
| VM storage | `C:\VMs` (not under OneDrive, so VM disks are not synced) |

## Network design

All lab traffic stays on `VMnet2`, a host-only network with no route to the home network or the internet.

![VMnet2 host-only network](../screenshots/01-setup/vmnet2-host-only-network.png)

| Setting | Value |
|---|---|
| Network | `VMnet2` |
| Type | Host-only |
| Subnet | `192.168.56.0` / `255.255.255.0` |
| Local DHCP | Off (fixed IPs) |
| Host virtual adapter | Connected (so the Wazuh dashboard opens from the host browser) |

Planned addresses:

| VM | IP (static) | Adapter |
|---|---|---|
| Wazuh | `192.168.56.10` | VMnet2 |
| Windows victim | `192.168.56.20` | VMnet2 (plus a temporary NAT adapter for installs) |
| Kali | `192.168.56.30` | VMnet2 |

## VM sizing

| VM | RAM | vCPU | Disk |
|---|---|---|---|
| Wazuh | 4 GB | 2 | 50 GB (grows as used) |
| Windows 10 victim | 4 GB | 2 | 50 GB (grows as used) |
| Kali | 2 GB | 2 | pre-built image |

## Wazuh first boot

The OVA boots to its login prompt (`wazuh-server`, version 4.14.9) on `VMnet2`.

![Wazuh first boot](../screenshots/01-setup/wazuh-first-boot.png)

## Notes and issues

- **Third-party ISO rejected.** A "Windows 10 Lite Edition" ISO was the first candidate. Repackaged "Lite" images usually strip Defender, Windows Update and telemetry, which are the log sources a SOC lab needs, and their contents can't be verified. Replaced with a standard `Win10_21H1_English_x64.iso`.
- **"is not a virtual machine configuration file (.vmx)".** VMware shows this when you try to open an ISO with **File → Open**. An ISO is not opened that way: use **Create a New Virtual Machine → Installer disc image file** instead.
- **Keep VMs out of OneDrive.** Moved the `VMs` folder from the Desktop (OneDrive-backed) to `C:\VMs` before importing anything.
- **Don't store VMs on `D:`.** It is a removable USB drive, which is too slow for VM disks.

## Next

Create the Windows victim VM, then set static IPs and take snapshots. See [`../02-logging/`](../02-logging/) for the Sysmon and agent steps.
