extends Node3D

@export var debug = false
@export var enemyDelay = 50.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if debug:
		EnemyManager.spawnInterval += enemyDelay


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
