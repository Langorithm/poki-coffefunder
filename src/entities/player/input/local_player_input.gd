class_name LocalPlayerInput
extends PlayerInput

## Translates local hardware input into the PlayerInput interface.
## Unifies keyboard, mouse, gamepad, and virtual joystick into a single source.
## Scope: reads raw input and emits what the player physically did — not what the game
## should do with it. Game logic (bullet spawning, auto-aim resolution) belongs in Player.
##
## Input Map actions required: move_left, move_right, move_up, move_down,
##                              aim_left, aim_right, aim_up, aim_down, special, fire
##
## Fire sources:
##   Virtual joystick tap (<200ms)  → aim_triggered(Vector2.ZERO)
##   Virtual joystick drag release  → aim_triggered(direction)
##   Mouse left click / gamepad     → aim_triggered(aim_vector)  [via 'fire' action]
##   Gamepad                        → not yet mapped (prototype gap)

@export var player_id: int = 0

const TAP_MAX_MS: float = 200.0


func _ready() -> void:
	EventBus.aim_tapped.connect(_on_aim_tapped)
	EventBus.aim_drag_ended.connect(_on_aim_drag_ended)


func _process(_delta: float) -> void:
	motion_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	var analog_aim := Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")
	is_analog_aim = analog_aim != Vector2.ZERO
	aim_vector = analog_aim if is_analog_aim else _get_mouse_aim()

	if Input.is_action_just_pressed("special"):
		special_pressed.emit()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("fire"):
		aim_triggered.emit(aim_vector)


func _get_mouse_aim() -> Vector2:
	var player := get_parent() as CharacterBody2D
	if player == null:
		return Vector2.ZERO
	var dir := player.get_global_mouse_position() - player.global_position
	if dir.length_squared() < 1.0:
		return Vector2.ZERO
	return dir.normalized()


func _on_aim_tapped(id: int, held_ms: float) -> void:
	if id != player_id or held_ms >= TAP_MAX_MS:
		return
	aim_triggered.emit(Vector2.ZERO)


func _on_aim_drag_ended(id: int, direction: Vector2) -> void:
	if id != player_id or direction == Vector2.ZERO:
		return
	aim_triggered.emit(direction)
