extends Node3D

@export var debug = false
@export var enemyDelay = 50.0
@export var starFoxCamera : Camera3D
@export var starFoxPathFollow : PathFollow3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if debug:
		EnemyManager.spawnInterval += enemyDelay
	var playerShip : PlayerController = find_child("PlayerShip")
	playerShip.starFoxCamera = starFoxCamera
	playerShip.SwapMode(StateManager.State.STARFOX)
	playerShip.currentState.originalBasis = starFoxPathFollow.basis


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	starFoxPathFollow.progress += delta * 3
