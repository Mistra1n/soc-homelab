# Attack: <name>

**Date:** YYYY-MM-DD
**Attacker → Target:** `kali (<ip>)` → `ubuntu-dvwa (<ip>)` via pfSense

## 1. Objective

What is being tested and what firewall behavior it's meant to prove.

## 2. Before — no blocking rule

```bash
# exact commands run from Kali
```

Result: <succeeded / what was exposed>
Screenshot: `../screenshots/<file>.png`

## 3. Firewall rule applied

Rule summary (full detail lives in [`../02-firewall-config/`](../02-firewall-config/)):

## 4. After — rule in place

```bash
# same commands, re-run
```

Result: <blocked / what changed>
pfSense log entry confirming the block:
Screenshot: `../screenshots/<file>.png`

## 5. Lessons learned

