class_name AimJoystick
extends VirtualJoystick

## Extends VirtualJoystick with tap detection.
## A tap is a touch that releases before is_pressed ever becomes true
## (i.e. the finger never left the deadzone — no actual aim drag occurred).

@export var player_id: int = 0

var _tracking_touch: int = -1
var _was_aimed: bool = false


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed and _tracking_touch == -1:
			if _is_point_inside_joystick_area(event.position):
				_tracking_touch = event.index
				_was_aimed = false
		elif not event.pressed and event.index == _tracking_touch:
			if not _was_aimed:
				EventBus.aim_tap_requested.emit(player_id)
			_tracking_touch = -1
	super._input(event)


func _process(delta: float) -> void:
	if _tracking_touch != -1 and is_pressed:
		_was_aimed = true
