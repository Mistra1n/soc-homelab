# 01 · Setup: hypervisor, network, and VMs

## Status

- [x] Free disk space confirmed (~100 GB on C:)
- [x] VMware Workstation Pro 17 installed
- [x] Isolated host-only network created (`VMnet2`, `192.168.56.0/24`, DHCP off)
- [x] Kali VM imported (official VMware pre-built image, 2026.2)
- [x] Wazuh server imported (OVA 4.14.9), boots to login, `clean-import` snapshot taken
- [x] Windows 10 21H1 ISO downloaded (5.7 GB)
- [x] Windows victim VM created (Windows 10 21H1, `win-victim`)
- [x] Static IP on Wazuh (`192.168.56.10`), persistent via systemd-networkd
- [x] Static IP on Windows victim (`192.168.56.20`), reaches Wazuh over VMnet2
- [ ] Static IP on Kali (`192.168.56.30`)
- [ ] Temporary NAT adapter on the victim for downloads (Sysmon, Wazuh agent)
- [ ] `clean-install` snapshot of Kali and the Windows victim

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

## Verified connectivity

Wazuh keeps its address across restarts of the network service because it is set in a systemd-networkd file, not just with `ip addr add`:

```ini
# /etc/systemd/network/10-lab.network
[Match]
Name=eth0

[Network]
Address=192.168.56.10/24
```

![Wazuh static IP](../screenshots/01-setup/wazuh-static-ip.png)

The Windows victim has one adapter on VMnet2 with `192.168.56.20/24` and no gateway. It reaches Wazuh (4/4 replies) and cannot reach the internet (`8.8.8.8` fails), which confirms it is isolated.

![win-victim ping](../screenshots/01-setup/win-victim-ping-wazuh.png)

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
- **Windows adapter name.** With a single adapter the interface is `Ethernet0`, not `Ethernet1`. `New-NetIPAddress -InterfaceAlias "Ethernet1"` failed with "Invalid parameter" until the real name was found with `Get-NetAdapter`.
- **First pings failed with "General failure".** The new static address was still `Tentative` (duplicate address detection). It cleared after a few seconds.
- **Ping TTL.** Replies from Wazuh show TTL=127 rather than Linux's usual 64. The Windows victim has no other route, so the replies come straight from Wazuh over VMnet2.
- **Typing in the Wazuh console.** The VM console cannot paste, so the config heredoc was first mistyped (`/ete/` instead of `/etc/`, then a wrong service name) and the file was never written. It worked when retyped carefully. For longer configs, SSH in from the host (`ssh wazuh-user@192.168.56.10`) where pasting works.
- **Keep VMs out of OneDrive.** Moved the `VMs` folder from the Desktop (OneDrive-backed) to `C:\VMs` before importing anything.
- **Don't store VMs on `D:`.** It is a removable USB drive, which is too slow for VM disks.

## Next

Give the victim a temporary NAT adapter so it can download Sysmon and the Wazuh agent, install both, then remove the NAT adapter. See [`../02-logging/`](../02-logging/) for the steps.
