class_name Player
extends CharacterBody2D

const SPEED: float = 200.0

@onready var _input: PlayerInput = %PlayerInput


func _ready() -> void:
	_input.auto_aim_requested.connect(_on_auto_aim_requested)


func _physics_process(_delta: float) -> void:
	velocity = _input.motion_vector * SPEED
	move_and_slide()

	# if _input.aim_vector != Vector2.ZERO:
	# 	rotation = _input.aim_vector.angle()


func _on_auto_aim_requested() -> void:
	# TODO: resolve nearest enemy, write result back to _input.aim_vector
	print("fire!")
	pass
