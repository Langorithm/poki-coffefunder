class_name Bullet
extends Area2D

## Player projectile. Travels in a fixed direction until it hits a damageable body or leaves range.
## Scope: owns its own movement and collision response — does not know who fired it.
## Damage is applied via HealthComponent metadata (ADR-004).

const SPEED: float = 500.0
const MAX_RANGE: float = 700.0

var direction: Vector2 = Vector2.RIGHT
var _traveled: float = 0.0


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _physics_process(delta: float) -> void:
	var step := direction * SPEED * delta
	position += step
	_traveled += step.length()
	if _traveled >= MAX_RANGE:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	var hc := HealthComponent.of(body)
	if hc:
		hc.take_damage(1)
	queue_free()
