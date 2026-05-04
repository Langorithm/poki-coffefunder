---
type: index
tags: [design, tech]
---

# Design & Tech

> [!NOTE] Scope
> Zero-level model — no manual level design. Procedural + roguelite loops protect the 60-day runway.

## Game Design

- [[📐 design/core-loops]] — Micro / Meso / Macro loop breakdown
- [[📐 design/feel-and-juice]] — Combat feedback, VFX language
- [[📐 design/upgrades]] — Roguelite upgrade pool (.tres Resources)
- [[📐 design/meta-shop]] — Permanent upgrades, gold sink, ad triggers

## Architecture & ADRs

- [[adr-001-input-decoupling]] — Player receives vectors from LocalPlayerInput, never reads Input directly
- [[export-size-optimization]] — Web export target 8–10MB compressed; custom template flags, module allowlist, wasm-opt
- [[adr-002-player-manager]] — ID-indexed entity tracking, no player singletons
- [[adr-003-poki-manager]] — Centralized Autoload for all Poki SDK / JS bridge calls

## Systems

- [[📐 design/systems/wave-spawner]]
- [[📐 design/systems/upgrade-resource]]
- [[📐 design/systems/poki-manager]]

## Poki

- [[Poki Resources]] — SDK setup, lifecycle, monetization flows, signals reference
