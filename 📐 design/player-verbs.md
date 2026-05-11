---
type: design
tags: [design, gameplay, input, player]
date: 2026-05-10
status: active
---

# Player Verbs

> [!NOTE] Design Reference
> Input scheme is directly modeled on Brawl Stars. Encounter and enemy design should be derived from this, not the other way around.

## Input Layout

| Input | Platform | Action |
|---|---|---|
| Left joystick / WASD | All | Move |
| Right joystick drag / Arrow keys | All | Aim + fire (release to fire) |
| Right joystick tap | Touch (virtual joystick only) | Auto-aim fire |
| Dedicated button (TBD) | Physical controller | Auto-aim fire equivalent |
| Special button / Gamepad B | All | Special power (TBD) |

### Input Targets by Platform

- **Touch (virtual joystick) — primary design target.** All UX decisions default to this platform.
- **Physical controller (PC or mobile gamepad)** — supported. Since real joysticks have tactile feedback, drag-aim is less costly. The right-stick tap doesn't translate cleanly, so auto-aim maps to a dedicated button instead (e.g. R3 or a face button — TBD).
- **Mouse + keyboard** — supported. Mouse provides precise aim natively; auto-aim is not needed and should not interfere.

> [!TODO] Haptics Research
> Investigate Godot's haptic capabilities for Android and iOS. Virtual joystick feedback (tap, drag start, fire) is a likely use case. Expand this section once Godot's mobile haptics API is understood.

## Primary Verb — Shoot

Move and aim are inseparable. Where the player stands determines available angles and threat exposure. Where they aim determines what gets hit and when. The core challenge is navigating both simultaneously — moving to create a good shot while avoiding damage.

Drag right joystick to aim. Releasing fires.

### Tap-to-Auto-Aim

Tapping the right joystick fires toward the nearest valid target. Only active on touch / virtual joystick. Not available to mouse players (who have precise aim already).

**Why this exists:** Virtual joysticks have no tactile feedback, making precise drag-aim more costly than on a real controller. A tap is the most natural, lowest-friction touch action. This gives players a reliable fallback that doesn't require precision.

| Gesture | Outcome |
|---|---|
| Quick tap (<200ms), no drag | Auto-aim fire |
| Hold in center (≥200ms) | Canceled — no shot |
| Drag, release outside center | Fires in aimed direction |
| Drag, return to center, release | Canceled — no shot |

**The skill expression:** Drag-aim gives full directional control at the cost of time and tension. Tap fires instantly but surrenders aim control. Skilled players learn to read situations — drag for precision (burst moment, specific target), tap for speed (panic, chaff clearing, mobile play). This duality is intentional and should be preserved in encounter design.

Auto-aim always fires at the target's *current* position, not a predicted one. This means moving targets are easy to dodge if they just keep moving. The real skill expression is learning to *predict* paths: a player who understands this will drag-aim slightly ahead of a moving enemy, while a beginner will tap and miss. Brawl Stars players develop this intuition quickly — enemies should be designed to reward it.

> [!TIP] Encounter Design Implication
> Enemies and encounters should create situations where *both* verbs are useful. Enemies that move sideways stress-test auto-aim and reward drag prediction. Enemies in clusters punish mindless auto-aim and reward target selection. If tap always works, drag becomes irrelevant — avoid that.

## Secondary Verb — Special

Mapped to `special` action (Gamepad B, Keyboard TBD).

Think of it as Mario's B button to the jump A. It's the power move — contextual, cooldown-gated, higher skill ceiling. Exact mechanic TBD (dash is the current placeholder concept).

> [!WARNING] Do not overload Special
> Special should not be a second attack. It's a movement/defensive/utility verb. Keeping it distinct preserves the clarity of the shoot-to-win loop.
