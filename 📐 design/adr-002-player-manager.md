---
type: adr
tags: [adr, tech, architecture, multiplayer]
status: accepted
date: 2026-05-03
---

## Decision

No singletons for player referencing. Players are tracked by an `EntityManager` autoload using ID/index lookup.

## Context

A common pattern in Godot is to use a `PlayerManager` singleton or `get_tree().get_nodes_in_group("player")[0]` to find the player. Both break immediately with more than one player and make multiplayer a rearchitect rather than an extension.

`EntityManager` maintains a dictionary of players keyed by `player_id: int`. Any system that needs to reference a player queries by ID rather than holding a direct node reference.

`player_id: int` is already defined on `LocalPlayerInput` and `AimJoystick` in preparation for this.

## Consequences

- Systems that need the player query `EntityManager` by ID — no hardcoded references
- Single-player launch works identically to co-op — no special-casing needed later
- Slight indirection vs. a direct node reference (negligible at this scale)

## Rejected Alternatives

| Alternative | Reason rejected |
|---|---|
| `PlayerSingleton` autoload | Hardcodes single player, rearchitect required for co-op |
| `get_nodes_in_group("player")[0]` | Order not guaranteed, breaks with multiple players |
| Direct node path (`$World/Player`) | Fragile to scene restructuring, impossible to network |
