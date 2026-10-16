# 04 · Detection rules

Custom Wazuh rules live in `local_rules.xml` (on the server: `/var/ossec/etc/rules/local_rules.xml`).

| Rule ID | Detects | MITRE | Tested against |
|---|---|---|---|
| 100001 | Repeated failed Windows logons (brute force) | T1110 | 03-attack-simulations/02 |

## Workflow

1. Run the attack and note the events produced.
2. Find the matching log fields in Wazuh (`Discover` / `wazuh-archives`).
3. Write the rule, restart `wazuh-manager`, replay the attack.
4. Record false positives and tune.
