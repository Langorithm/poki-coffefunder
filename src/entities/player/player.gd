class_name Player
extends CharacterBody2D

## Owns the player's movement and combat state.
## Scope: translates PlayerInput into velocity and projectile firing.
## Does not know about the world — bullets are spawned into get_parent().

const SPEED: float = 190.0
const BULLET_SCENE: PackedScene = preload("res://entities/player/bullet/bullet.tscn")
const MAX_AMMO: int = 5
const RELOAD_TIME: float = 3.0

signal ammo_changed(current: int, max_ammo: int)
signal reload_started(duration: float)
signal reload_finished

@onready var _input: PlayerInput = %PlayerInput
@onready var _health: HealthComponent = $HealthComponent

var _ammo: int = MAX_AMMO
var _reload_elapsed: float = 0.0
var _reloading: bool = false


func _ready() -> void:
	add_to_group("player")
	_input.aim_triggered.connect(_on_aim_triggered)
	_health.died.connect(queue_free)
	ammo_changed.emit.call_deferred(_ammo, MAX_AMMO)


func _physics_process(delta: float) -> void:
	velocity = _input.motion_vector * SPEED
	move_and_slide()

	if _reloading:
		_reload_elapsed += delta
		if _reload_elapsed >= RELOAD_TIME:
			_ammo = MAX_AMMO
			_reloading = false
			reload_finished.emit()
			ammo_changed.emit(_ammo, MAX_AMMO)


func _on_aim_triggered(direction: Vector2) -> void:
	if _reloading:
		return

	var actual_dir := direction
	if actual_dir == Vector2.ZERO:
		actual_dir = _nearest_enemy_dir()
	if actual_dir == Vector2.ZERO:
		actual_dir = _input.aim_vector
	if actual_dir == Vector2.ZERO:
		return

	var bullet := BULLET_SCENE.instantiate() as Bullet
	bullet.global_position = global_position
	bullet.direction = actual_dir
	get_parent().add_child(bullet)

	_ammo -= 1
	ammo_changed.emit(_ammo, MAX_AMMO)
	if _ammo == 0:
		_reloading = true
		_reload_elapsed = 0.0
		reload_started.emit(RELOAD_TIME)


func _nearest_enemy_dir() -> Vector2:
	var enemies := get_tree().get_nodes_in_group("enemies")
	var nearest: Node2D = null
	var nearest_dist := INF
	for enemy: Node2D in enemies:
		var d := global_position.distance_squared_to(enemy.global_position)
		if d < nearest_dist:
			nearest_dist = d
			nearest = enemy
	if nearest == null:
		return Vector2.ZERO
	return (nearest.global_position - global_position).normalized()
