class_name AimJoystick
extends VirtualJoystick

## Right-stick gesture detector.
## Distinguishes tap from drag and always reports both to EventBus — no filtering.
## LocalPlayerInput decides what each gesture means for gameplay.
##
## Gesture table (design reference: player-verbs.md):
##   Quick tap (<200ms)              → aim_tapped(player_id, held_ms)
##   Hold in center (≥200ms)         → aim_tapped(player_id, held_ms)  [caller ignores]
##   Drag, release outside center    → aim_drag_ended(player_id, direction)
##   Drag, return to center, release → aim_drag_ended(player_id, Vector2.ZERO)  [caller ignores]

@export var player_id: int = 0

var _tracking_touch: int = -1
var _was_dragged: bool = false
var _touch_start_ms: float = 0.0


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed and _tracking_touch == -1:
			if _is_point_inside_joystick_area(event.position):
				_tracking_touch = event.index
				_was_dragged = false
				_touch_start_ms = Time.get_ticks_msec()
		elif not event.pressed and event.index == _tracking_touch:
			if not _was_dragged:
				var held_ms := Time.get_ticks_msec() - _touch_start_ms
				EventBus.aim_tapped.emit(player_id, held_ms)
			else:
				# Capture output before super._input resets it to zero.
				EventBus.aim_drag_ended.emit(player_id, output)
			_tracking_touch = -1
	super._input(event)


func _process(_delta: float) -> void:
	if _tracking_touch != -1 and is_pressed and not _was_dragged:
		_was_dragged = true
		EventBus.aim_drag_started.emit(player_id)
