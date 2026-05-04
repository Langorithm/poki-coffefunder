class_name LocalPlayerInput
extends PlayerInput

## Reads keyboard, gamepad, and virtual joystick inputs.
## Joystick nodes (visibility_mode = TOUCHSCREEN_ONLY) inject into the
## Input Map directly — motion and aim use Input.get_vector() for all sources.
## Mouse aim is a fallback when no analog aim input is active.
## Tap-to-auto-aim is received via EventBus from AimJoystick.

@export var player_id: int = 0


func _ready() -> void:
	EventBus.aim_tap_requested.connect(_on_aim_tap_requested)


func _process(_delta: float) -> void:
	motion_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	var analog_aim := Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")
	aim_vector = analog_aim if analog_aim != Vector2.ZERO else _get_mouse_aim()

	if Input.is_action_just_pressed("special"):
		special_pressed.emit()


func _get_mouse_aim() -> Vector2:
	var player := get_parent() as CharacterBody2D
	if player == null:
		return Vector2.ZERO
	var dir := player.get_global_mouse_position() - player.global_position
	if dir.length_squared() < 1.0:
		return Vector2.ZERO
	return dir.normalized()


func _on_aim_tap_requested(id: int) -> void:
	if id != player_id:
		return
	auto_aim_requested.emit()
