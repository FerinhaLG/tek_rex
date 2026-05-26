# Tek-Rex

**IBM Mainframe Specialist AI** — a Claude Code–powered assistant with deep, document-grounded expertise on z/OS and the broader IBM mainframe ecosystem.

---

## What It Is

Tek-Rex is a local AI assistant configured to answer mainframe questions with the precision of a seasoned systems programmer. Every response is grounded in official IBM documentation — no paraphrasing from training data, no guesswork. It uses correct IBM terminology throughout: *data set*, *abend*, *DASD*, *PDSE*, *cataloged procedure*.

---

## Knowledge Base

The `docs/` folder contains the full IBM z/OS 3.1 manual set, organized by product area:

| Folder | Coverage |
|---|---|
| `docs/zos-mvs/` | JCL, system codes, system messages (10 vols), initialization, sysplex, WLM |
| `docs/zos-unix/` | z/OS UNIX System Services, OpenSSH |
| `docs/tso-rexx/` | TSO/E user guide, commands, customization + REXX reference and user guide |
| `docs/racf/` | RACF admin, command reference, messages, system programmer guide |
| `docs/jes/` | JES2 commands, init & tuning |
| `docs/sms/` | DFSMS data sets, catalogs, IDCAMS, macros, DFSMSrmm |
| `docs/ispf/` | ISPF user guides (2 vols), services guide, dialog developer guide |
| `docs/smf-rmf/` | RMF user guide, report analysis, messages |
| `docs/networking/` | TCP/IP config, user guide, SNA, IP messages, codes |
| `docs/utilities/` | DFSMSdfp utilities (IEBGENER, IEBCOPY, etc.), DFSORT |
| `docs/sdsf/` | SDSF operation and customization |
| `docs/zosmf/` | z/OSMF configuration and programming |
| `docs/automation/netview/` | IBM Z NetView 6.4 — automation guide, command refs, admin, messages |
| `docs/automation/sa-zos/` | IBM Z System Automation 4.4 — planning, operators guide, messages |

Full manifest with order numbers and filenames: [`docs/INDEX.md`](docs/INDEX.md)

---

## Skills (Slash Commands)

| Command | Purpose |
|---|---|
| `/jcl` | JCL job builder — every statement and parameter, all utilities (IEBGENER, IEBCOPY, IDCAMS, DFSORT), full templates |
| `/rexx` | REXX programming specialist — syntax, TSO/E extensions, EXECIO, debugging |
| `/log-analyzer` | Message ID specialist — routes any IBM message prefix to the exact manual, diagnoses abends, RACF events, storage and I/O errors |

---

## Code Formatting Conventions

| Language | Fence |
|---|---|
| JCL | ` ```jcl ` |
| REXX | ` ```rexx ` |
| RACF commands | ` ```racf ` |
| TSO commands | ` ```tso ` |
| z/OS UNIX shell | ` ```sh ` |
| IDCAMS | ` ```idcams ` |

---

## Scope

- All documentation is **z/OS version 3.1** unless otherwise specified.
- Error codes always include the system completion code (e.g. `S0C7`, `S322`), reason code where applicable, and the IBM manual that defines it.
- Responses reference the document title and section rather than paraphrasing from memory.
