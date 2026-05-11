extends Node

## Global event bus for decoupled communication between systems.
## Add signals here as new cross-system events are needed.

# Input events
signal aim_tapped(player_id: int, held_ms: float)
signal aim_drag_started(player_id: int)
signal aim_drag_ended(player_id: int, direction: Vector2)

# Player combat state
signal ammo_changed(current: int, max_ammo: int)
signal reload_started(duration: float)
signal reload_finished

# Camera
signal camera_shake(intensity: float, duration: float)
