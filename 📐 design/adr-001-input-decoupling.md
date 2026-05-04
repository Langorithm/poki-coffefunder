---
type: adr
tags: [adr, tech, input, architecture]
status: accepted
date: 2026-05-03
---

# ADR-001 — Input Decoupling

## Decision

`Player` never reads `Input` directly. All input is received through a `PlayerInput` node that lives inside the Player subscene.

## Context

The game is designed to support co-op multiplayer without rearchitecting. If `Player` reads `Input` directly, adding a second player or network control requires rewriting the player script. Decoupling input from player logic from day one avoids this.

`PlayerInput` is an abstract base class. Concrete implementations:
- `LocalPlayerInput` — reads keyboard, gamepad, and virtual joystick via the Input Map
- `NetworkPlayerInput` — (future) receives vectors over the network

`Player` holds a reference typed as `PlayerInput` only — never as a concrete subclass.

`player_id: int` is defined on both `LocalPlayerInput` and `AimJoystick` for future multiplayer routing. `EventBus` is used for cross-node signals (e.g. tap-to-auto-aim) where direct references aren't available.

## Naming

`LocalPlayerInput` / `NetworkPlayerInput` — not `PlayerController`. `PlayerController` was rejected because it reads too close to `CharacterBody2D`'s role and implies control of physics, not just input.

## Consequences

- Logic (math, HP, physics) is decoupled from visuals and input — player can run headless
- Adding network multiplayer only requires implementing `NetworkPlayerInput`
- Slight indirection: Player must wait for `_input` node to be ready before reading vectors

## Rejected Alternatives

| Alternative | Reason rejected |
|---|---|
| `Player` reads `Input` directly | Breaks multiplayer — can't distinguish players, can't swap input source |
| Signals from joystick directly to Player | Creates tight coupling between HUD scene and Player subscene |
| Groups / `get_tree().get_nodes_in_group("player")` | Fragile, order-dependent, doesn't scale to multiplayer |
