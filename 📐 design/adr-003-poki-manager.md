---
type: adr
tags: [adr, tech, poki, monetization]
status: open
date: 2026-05-03
---

# ADR-003 — Poki SDK Integration Pattern

## Question

Where do Poki SDK calls live?

## Options

| Option                              | Notes                                                                                                        |
| ----------------------------------- | ------------------------------------------------------------------------------------------------------------ |
| `PokiManager` autoload              | Single place for state tracking and sequencing guards. Game code never touches `PokiSDK` directly.           |
| Call `PokiSDK` directly from scenes | Simpler upfront. Risk: sequencing rules (no duplicate calls, no calls during ads) scattered across codebase. |
| Thin wrapper, no state              | Somewhere in between. Still pushes sequencing responsibility to callers.                                     |
