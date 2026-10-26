# 02 · Firewall config — DHCP, DVWA deploy, and the rules

## 1. pfSense interface + DHCP

- LAN interface: static IP (default `192.168.1.1/24` is fine)
- LAN DHCP range: enable, e.g. `192.168.1.100–192.168.1.199`
- WAN interface: static or DHCP, matches the `pfsense-wan` segment Kali sits on

## 2. Deploy DVWA on Ubuntu

```bash
sudo apt update && sudo apt install -y apache2 php php-mysqli php-gd mariadb-server git
sudo git clone https://github.com/digininja/DVWA.git /var/www/html/dvwa
cd /var/www/html/dvwa
sudo cp config/config.inc.php.dist config/config.inc.php
# edit config.inc.php: db_user, db_password, db_database
sudo mysql -e "CREATE DATABASE dvwa; CREATE USER 'dvwa'@'localhost' IDENTIFIED BY '<password>'; GRANT ALL ON dvwa.* TO 'dvwa'@'localhost'; FLUSH PRIVILEGES;"
sudo systemctl restart apache2 mariadb
```
Visit `http://<ubuntu-ip>/dvwa/setup.php` from the LAN side to finish setup and set the DVWA security level (use **low** for the first pass).

## 3. Baseline: no firewall rules

With pfSense's default LAN rule (allow all from LAN to any) and **no WAN rule added yet**, confirm from Kali:

```bash
nmap -sV <ubuntu-ip>          # should fully succeed — this is the "before" state
```
This only works at all once a rule permits Kali's network to reach the LAN — pfSense denies everything inbound to LAN by default. So "baseline" here means: add one permissive rule (WAN → LAN, any/any) just to prove the path works end-to-end and DVWA is attackable, then move to the real test.

## 4. Attack rules — what to write and why

| Rule | Action | Source | Dest | Why |
|---|---|---|---|---|
| 1 | Block | Kali's IP/subnet | Ubuntu, port 80 | Stop the specific attacker from reaching the web app directly |
| 2 | Allow | any | Ubuntu, port 80 | Legitimate traffic still gets through |
| 3 *(optional, stretch)* | Block | any | Ubuntu, suspicious ports (e.g. 22, if not needed externally) | Reduce attack surface beyond just the one host |

Order matters in pfSense — block rules above allow rules, most specific first. Screenshot the rule list into `../screenshots/`.

## 5. Verify

- [ ] Rules applied (pfSense auto-applies on save, confirm in **Status → System Logs → Firewall**)
- [ ] Kali's traffic now shows as blocked in the firewall log
- [ ] A different source (or `curl` from the pfSense box itself) still reaches DVWA fine

Next: [`03-attack-simulations/`](../03-attack-simulations/)
