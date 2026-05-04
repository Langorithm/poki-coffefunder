extends Node

## Global event bus for decoupled communication between systems.
## Add signals here as new cross-system events are needed.

# Input events
signal aim_tap_requested(player_id: int)
