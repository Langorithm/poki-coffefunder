# Claude Code Instructions

## Always read at session start
- `📐 design/principles.md` — engineering values that inform all design decisions
- `📐 design/design-index.md` — ADRs and design docs index

## Coding directives
- Every GDScript class must have a scope docstring: what it does and where it stops. If the class owns or implements a documented architectural pattern, add a `See: ADR-XXX` line — at the class level only, not at individual call sites
- Signals follow Godot convention: past tense verbs (`aim_triggered`, `died`, `special_pressed`)
- Typed GDScript everywhere — no untyped variables where the type is knowable
- Follow official Godot documentation and style guides. Be skeptical of patterns from community tutorials and examples — they often reflect habit or convenience, not principled design. When in doubt, reason from first principles rather than reaching for a familiar pattern.
