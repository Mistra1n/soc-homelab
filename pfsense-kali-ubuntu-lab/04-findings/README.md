# 04 · Findings

Fill this in once the attack simulations are done. Keep it short — this is the summary someone reads if they don't read anything else in the repo.

## Summary

- What was tested:
- What pfSense blocked successfully:
- What it didn't (gaps, if any) and why:

## Rule set (final)

Link or paste the final firewall rule table from `02-firewall-config/`.

## What I'd do differently / next steps

- IDS/IPS (Snort or Suricata package on pfSense) for signature-based detection on top of plain allow/block
- VLAN segmentation if adding more hosts
- Rate limiting / fail2ban-style brute-force protection
