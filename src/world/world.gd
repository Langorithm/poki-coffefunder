extends Node2D

## Top-level game loop for the wave survival scene.
## Scope: manages timers, enemy spawning, and win/lose conditions.
## Does not know about player mechanics or enemy behavior.

const SURVIVE_TIME: float = 40.0
const SPAWN_INTERVAL: float = .8
const ENEMY_SCENE: PackedScene = preload("res://entities/enemy/enemy.tscn")

@onready var _survive_timer: Timer = $SurviveTimer
@onready var _spawn_timer: Timer = $SpawnTimer
@onready var _timer_label: Label = $HUD/TimerLabel
@onready var _message_label: Label = $HUD/MessageLabel
@onready var _enemies: Node2D = $Enemies
@onready var _player_health: HealthComponent = $Player/HealthComponent

var _round_over: bool = false


func _ready() -> void:
	_player_health.died.connect(_on_player_died)
	_survive_timer.wait_time = SURVIVE_TIME
	_survive_timer.timeout.connect(_on_survived)
	_survive_timer.start()
	_spawn_timer.wait_time = SPAWN_INTERVAL
	_spawn_timer.timeout.connect(_on_spawn_timer)
	_spawn_timer.start()
	_message_label.hide()


func _process(_delta: float) -> void:
	_timer_label.text = str(ceili(_survive_timer.time_left))


func _on_spawn_timer() -> void:
	if _round_over:
		return
	var enemy := ENEMY_SCENE.instantiate() as Enemy
	enemy.position = _random_edge_position()
	_enemies.add_child(enemy)


func _random_edge_position() -> Vector2:
	var vp := get_viewport_rect()
	match randi() % 4:
		0: return Vector2(randf_range(0.0, vp.size.x), -32.0)
		1: return Vector2(randf_range(0.0, vp.size.x), vp.size.y + 32.0)
		2: return Vector2(-32.0, randf_range(0.0, vp.size.y))
		_: return Vector2(vp.size.x + 32.0, randf_range(0.0, vp.size.y))


func _on_survived() -> void:
	_end_round("YOU SURVIVED!")


func _on_player_died() -> void:
	_survive_timer.stop()
	_end_round("GAME OVER")


func _end_round(message: String) -> void:
	_round_over = true
	_spawn_timer.stop()
	_message_label.text = message
	_message_label.show()
	get_tree().create_timer(2.0).timeout.connect(
		func(): get_tree().reload_current_scene()
	)
