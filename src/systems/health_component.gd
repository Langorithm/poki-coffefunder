class_name HealthComponent
extends Node

## Tracks HP for an entity and signals damage and death.
## Scope: owns HP state and emits events — does not know what entity it belongs to
## or what happens on death. Callers decide how to respond to died/damaged.
##
## Registers itself on its scene owner via metadata so external systems can reach it
## without inspecting foreign scene structure. Assumes owner is the collidable root
## of the entity's scene (CharacterBody2D, Area2D, etc.).
## Does not support dynamic add_child without explicitly setting owner.
## See: ADR-004 (metadata registration), ADR-005 (HealthComponent.of() lookup)

signal died
signal damaged(amount: int, current_hp: int)


static func of(node: Node) -> HealthComponent:
	return node.get_meta("health_component", null)

@export var max_hp: int = 3
var hp: int


func _ready() -> void:
	assert(owner != null, "HealthComponent requires a scene owner. Do not add dynamically without setting owner.")
	hp = max_hp
	await owner.ready
	owner.set_meta("health_component", self)


func _exit_tree() -> void:
	if owner and owner.has_meta("health_component"):
		owner.remove_meta("health_component")


func take_damage(amount: int) -> void:
	if hp <= 0:
		return
	hp = max(0, hp - amount)
	damaged.emit(amount, hp)
	if hp == 0:
		died.emit()
