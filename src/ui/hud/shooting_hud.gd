class_name ShootingHUD
extends Node2D

## Unified shooting feedback HUD: ammo pips and aim direction indicator.
## Scope: pure display — reads Player signals and PlayerInput state, never writes game state.
## Lives in the HUD CanvasLayer so both elements share one group lookup and one node.
## Aim line uses screen-space coordinates converted from player world position via get_canvas_transform().
##
## Single-player assumption: connects to the first node in group "player".
## For MP, match player_id: get_nodes_in_group("player").filter(...)

@export var color_full: Color = Color.WHITE
@export var color_empty: Color = Color(1.0, 1.0, 1.0, 0.25)
@export var color_reload: Color = Color(1.0, 0.8, 0.2)

@onready var _aim_pivot: Node2D = $AimPivot
@onready var _pips: HBoxContainer = $AmmoPips

var _player: Player
var _player_input: PlayerInput
var _ammo: int = 0
var _reloading: bool = false
var _reload_elapsed: float = 0.0
var _reload_duration: float = 1.0
var _pips_offset: Vector2


func _ready() -> void:
	_pips_offset = _pips.position
	_player = get_tree().get_first_node_in_group("player") as Player
	if _player == null:
		return
	_player_input = _player.get_node("%PlayerInput") as PlayerInput
	_player.ammo_changed.connect(_on_ammo_changed)
	_player.reload_started.connect(_on_reload_started)
	_player.reload_finished.connect(_on_reload_finished)


func _process(delta: float) -> void:
	_update_aim_line()
	_update_pips_position()
	if _reloading:
		_reload_elapsed += delta
		_update_pips()


func _update_pips_position() -> void:
	if _player == null:
		return
	var screen_pos := get_viewport().get_canvas_transform() * _player.global_position
	_pips.position = screen_pos + _pips_offset


func _update_aim_line() -> void:
	if _player == null or _player_input == null or not _player_input.is_analog_aim or _player_input.aim_vector == Vector2.ZERO:
		_aim_pivot.visible = false
		return
	_aim_pivot.visible = true
	_aim_pivot.position = get_viewport().get_canvas_transform() * _player.global_position
	_aim_pivot.rotation = _player_input.aim_vector.angle()


func _update_pips() -> void:
	var pip_nodes := _pips.get_children()
	for i in pip_nodes.size():
		var pip := pip_nodes[i] as ColorRect
		if _reloading:
			var progress := (_reload_elapsed / _reload_duration) * pip_nodes.size()
			pip.modulate = color_reload if i < progress else color_empty
		else:
			pip.modulate = color_full if i < _ammo else color_empty


func _on_ammo_changed(current: int, _max_ammo: int) -> void:
	_ammo = current
	_update_pips()


func _on_reload_started(duration: float) -> void:
	_reloading = true
	_reload_elapsed = 0.0
	_reload_duration = duration
	_update_pips()


func _on_reload_finished() -> void:
	_reloading = false
	_update_pips()
