---
type: adr
tags: [adr, tech, entities]
status: accepted
date: 2026-05-10
---

# ADR-004 — Damage Application via HealthComponent Metadata

## Decision

`HealthComponent` registers itself on its scene `owner` via `set_meta("health_component", self)`. Damage-dealers check `has_meta` — no type checks, no foreign scene navigation.

## Rejected

- `is Player` + `get_node_or_null("HealthComponent")` — couples damage-dealers to specific classes and internal scene structure
- `Damageable` abstract class — inheritance for a capability better granted by composition (see [[principles]])

## Constraints

- `owner` must be the collidable physics body — it's the node that appears as `collider` in physics callbacks
- HC must be placed in a saved scene; dynamic `add_child` without setting `owner` is not supported (asserted at runtime)
- `await owner.ready` required — Godot's bottom-up ready order means `owner` isn't initialized when HC's `_ready` fires
