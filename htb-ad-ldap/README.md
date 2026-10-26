# HTB Academy — Active Directory LDAP

Write-up and notes for HTB Academy's **Active Directory LDAP** module (Tier 3, Medium, ~2 days estimated by HTB): AD fundamentals, LDAP and AD search filters, and enumerating AD with built-in/living-off-the-land tools, finishing with the module's skills assessment.

> **Status:** 🚧 In progress — see [progress](#progress) below.

## Why this module

Builds directly on `Linux Fundamentals` and `Introduction to Networking` and feeds into the next AD modules (`PowerView`, `BloodHound`). LDAP enumeration is the foundation for basically everything else in AD attack paths, so this is the one to actually understand deeply rather than rush.

## Progress

- [ ] 01 · AD fundamentals (overview, rights/privileges, RSAT, why `NT AUTHORITY\SYSTEM` matters)
- [ ] 02 · LDAP overview + AD/LDAP search filters, enumerating with built-in tools
- [ ] 03 · LDAP enumeration (anonymous bind, credentialed)
- [ ] 04 · Skills assessment

## Repo layout

| Folder | Maps to HTB section(s) |
|---|---|
| [`01-ad-fundamentals/`](01-ad-fundamentals/) | Active Directory Overview · Why Enumerate AD? · Rights and Privileges in AD · RSAT · The Power of NT AUTHORITY\SYSTEM |
| [`02-ldap-and-search-filters/`](02-ldap-and-search-filters/) | LDAP Overview · AD Search Filters · LDAP Search Filters · Enumerating AD with Built-in Tools |
| [`03-ldap-enumeration/`](03-ldap-enumeration/) | LDAP Anonymous Bind · Credentialed LDAP Enumeration |
| [`04-skills-assessment/`](04-skills-assessment/) | Skills Assessment write-up |
| [`screenshots/`](screenshots/) | Evidence for each section |

Each section folder has a `notes.md` — concepts + every command/query actually run, in my own words, not copy-pasted from the module.

## Tools

LDAP (`ldapsearch`), RSAT, native Windows/AD built-in enumeration tools, Pwnbox
