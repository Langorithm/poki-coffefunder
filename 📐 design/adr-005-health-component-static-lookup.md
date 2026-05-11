---
type: adr
tags: [adr, tech, entities]
status: accepted
date: 2026-05-10
---

# ADR-005 — HealthComponent.of() Static Lookup

## Decision

`HealthComponent` exposes a static method `of(node: Node) -> HealthComponent` that wraps the metadata lookup. All callers use this instead of touching `get_meta` / `has_meta` directly.

```gdscript
static func of(node: Node) -> HealthComponent:
    return node.get_meta("health_component", null)
```

All call sites use an explicit null check:

```gdscript
var hc := HealthComponent.of(node)
if hc == null:
    continue
hc.take_damage(1)
_do_something_else()
```

## Why

ADR-004 introduced the metadata pattern but left the lookup string `"health_component"` as a raw literal scattered across callers. If the key ever changes, every caller breaks silently — the compiler can't catch a string mismatch.

`of()` makes `HealthComponent` the single owner of its own lookup contract: the key is written in `_ready`, removed in `_exit_tree`, and read in `of()` — nowhere else.

## Rejected

- Leaving `has_meta` + `get_meta` inline — the raw string leaks into callers; two-line pattern adds noise at every damage site
- Extension method on `Node` — no precedent for monkey-patching Node in this codebase; adds noise to every Node in the IDE autocomplete

## Constraints

- `of()` returns `null` for any node that has no `HealthComponent` — callers must handle this (the `?.` operator or an explicit check)
- Follows from [[adr-004-damage-via-metadata]] — the metadata registration contract is unchanged
