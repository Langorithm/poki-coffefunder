class_name Enemy
extends CharacterBody2D

## Basic chaser enemy. Moves toward a target and deals contact damage.
## Scope: handles its own movement, contact damage, and death.
## Does not know what it is chasing — target is resolved via group lookup.
## Does not know what it is damaging — damage is applied via HealthComponent metadata (ADR-004).

@export_category("Movement")
@export var speed: float = 150.0

@export_category("Combat")
@export var damage_interval: float = 1.5

@onready var _health: HealthComponent = $HealthComponent
@onready var _sprite: Sprite2D = $Sprite2D
@onready var _damage_area: Area2D = $DamageArea

var _target: Node2D
var _damage_cooldown: float = 0.0
var _base_modulate: Color


func _ready() -> void:
	add_to_group("enemies")
	_base_modulate = _sprite.modulate
	_health.died.connect(queue_free)
	_health.damaged.connect(_on_damaged)


func _on_damaged(_amount: int, _hp: int) -> void:
	_sprite.modulate = Color.WHITE
	var tween := create_tween()
	tween.tween_property(_sprite, "modulate", _base_modulate, 0.15)


func _physics_process(delta: float) -> void:
	if _target == null:
		# TODO: replace with proper targeting system (proximity, line of sight, aggro state)
		_target = get_tree().get_first_node_in_group("player") as Node2D
		if _target == null:
			return

	if _damage_cooldown > 0.0:
		_damage_cooldown -= delta

	velocity = (_target.global_position - global_position).normalized() * speed
	move_and_slide()

	if _damage_cooldown <= 0.0:
		_check_contact_damage()


func _check_contact_damage() -> void:
	for body in _damage_area.get_overlapping_bodies():
		var hc := HealthComponent.of(body)
		if hc == null:
			continue
		hc.take_damage(1)
		_damage_cooldown = damage_interval
		return
