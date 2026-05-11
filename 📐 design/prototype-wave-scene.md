---
type: design
tags: [design, gameplay, prototype, wave]
date: 2026-05-10
status: active
---

# Prototype Wave Scene

Single scene used to validate core combat feel before building real wave/run structure.

## Win / Lose Conditions (v1)

| Condition | Trigger |
|---|---|
| **Win** | Survive 60 seconds |
| **Lose** | Player HP reaches 0 |

These are placeholders. Once combat feel is validated, this will be replaced by a proper wave and run structure with a roguelite upgrade loop.

## Scope

- One enemy type, chases player
- Player has HP, dies on contact or hit
- Player fires projectiles
- Timer counts 60 seconds; win state on expiry
- No upgrades, no shop, no meta — just the combat loop
