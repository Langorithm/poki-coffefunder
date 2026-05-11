class_name GameCamera
extends Camera2D

## Aim-priority camera for the player.
## Scope: drives Camera2D offset based on input state and shake events.
## Does not move the camera node itself — parenting to Player handles world tracking.
##
## Pan priority: analog aim → movement direction → recenter.
## Shake is additive on top of pan and triggered via EventBus.camera_shake.
## Note: EventBus shake is not MP-compatible (global signal hits all cameras).
## For MP, shake would need a player_id or direct signal on the Player. Not a concern for now.

@export var pan_distance: float = 80.0
@export var pan_speed: float = 4.0
@export var shake_speed: float = 12.0

var _player_input: PlayerInput
var _pan_offset: Vector2 = Vector2.ZERO
var _shake_intensity: float = 0.0
var _shake_duration: float = 0.0
var _shake_elapsed: float = 0.0


func _ready() -> void:
	_player_input = get_parent().get_node("%PlayerInput") as PlayerInput
	EventBus.camera_shake.connect(_on_camera_shake)


func _process(delta: float) -> void:
	_pan_offset = _pan_offset.lerp(_target_pan(), pan_speed * delta)
	offset = _pan_offset + _tick_shake(delta)


func _target_pan() -> Vector2:
	if _player_input.is_analog_aim and _player_input.aim_vector != Vector2.ZERO:
		return _player_input.aim_vector * pan_distance
	if _player_input.motion_vector != Vector2.ZERO:
		return _player_input.motion_vector * pan_distance * 0.4
	return Vector2.ZERO


func _tick_shake(delta: float) -> Vector2:
	if _shake_elapsed >= _shake_duration:
		return Vector2.ZERO
	_shake_elapsed += delta
	var t := 1.0 - (_shake_elapsed / _shake_duration)
	return Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)) * _shake_intensity * t


func _on_camera_shake(intensity: float, duration: float) -> void:
	_shake_intensity = intensity
	_shake_duration = duration
	_shake_elapsed = 0.0
