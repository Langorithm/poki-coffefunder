---
type: principles
tags: [principles, architecture, philosophy]
date: 2026-05-10
---

# Engineering Principles

## Composition over inheritance

Build capability through what a scene *contains*, not what class hierarchy it belongs to. A node becomes damageable by having a HealthComponent, not by extending a Damageable class. A player swaps input sources by holding a different PlayerInput, not by subclassing.

Inheritance is not forbidden — abstract base classes are useful for defining contracts. The distinction: inherit to define an interface, compose to grant capability.

## Names carry architecture

A name is a reasoning tool. Before settling on one, use it to interrogate the intent: what is this thing, what does it know about, what should it stay ignorant of, which layer does it live in? The name should follow from those answers — not the other way around.

When a name feels wrong or generates debate, treat that as a signal to stop and resolve the underlying intent before writing code. Don't wordsmith toward a name; reason toward the concept, and the name usually becomes obvious.

When semantics aren't clear, discuss them with the user. This is not bikeshedding — it surfaces design decisions that would otherwise be implicit and fragile.

`fire_requested` became `aim_triggered` not through wordsmithing but through understanding that the signal lives in the input layer, not the game mechanic layer.
