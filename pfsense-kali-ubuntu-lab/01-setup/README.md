# 01 · Setup — VirtualBox networks, VM shells, pfSense base install

## 1. Download

- [pfSense CE ISO](https://www.pfsense.org/download/)
- [Ubuntu Server 22.04 LTS ISO](https://ubuntu.com/download/server)
- [Kali Linux VirtualBox image or ISO](https://www.kali.org/get-kali/)

## 2. Networking plan

Three VirtualBox networks so nothing here touches your real LAN:

| Network | Type | Purpose |
|---|---|---|
| `pfsense-wan` | Internal Network (VirtualBox) | Kali ↔ pfSense WAN interface |
| `pfsense-lan` | Internal Network (VirtualBox) | pfSense LAN interface ↔ Ubuntu |
| *(optional)* `host-admin` | Host-only Adapter | Just for reaching the pfSense web GUI from your host browser |

```
Kali NIC1 ───► pfsense-wan ───► pfSense NIC1 (WAN)
                                 pfSense NIC2 (LAN) ───► pfsense-lan ───► Ubuntu NIC1
```

## 3. pfSense VM

- 1 vCPU, 1–2 GB RAM, 8–20 GB disk
- 2 network adapters: NIC1 → `pfsense-wan`, NIC2 → `pfsense-lan`
- Boot the ISO, accept defaults through install, assign WAN = NIC1 / LAN = NIC2 at the console

Record here once done:
- pfSense WAN IP: `___________`
- pfSense LAN IP: `___________` (default `192.168.1.1`, fine to keep)

## 4. Kali VM

- 2 vCPU, 2 GB RAM, 20 GB disk
- 1 network adapter → `pfsense-wan`
- Confirm it gets a DHCP lease from pfSense's WAN side (or set static — note which)

Kali IP: `___________`

## 5. Ubuntu Server VM

- 1 vCPU, 2 GB RAM, 20 GB disk
- 1 network adapter → `pfsense-lan`
- Minimal install is fine (DVWA stack goes on in setup step, not here)

Ubuntu IP: `___________`

## 6. Sanity check before moving on

- [ ] pfSense web GUI reachable from host (via `host-admin` or LAN-side browser)
- [ ] Kali can `ping` pfSense's WAN IP
- [ ] Ubuntu can `ping` pfSense's LAN IP
- [ ] Kali **cannot yet** reach Ubuntu directly (pfSense hasn't been told to allow/route it — confirms the chokepoint is real before you configure anything)

Screenshot the topology (VirtualBox network manager + `ip a` on all three) into `../screenshots/`.

Next: [`02-firewall-config/`](../02-firewall-config/)
