extends Node3D
class_name Missile

@export_category("Game Rules")
@export var movement_speed : float = 1.0
@export var damageAmount : float = 100.0
@export var acceleration : float = 0.0
@export var life_time : float = 5.0

var currentTarget
var startPosition
var timer = 0.0
# @export var sound_effect : Audio
# @export var particle_effect : GPUParticles3D

# will have issue that enemies shoot themselves
# so need to have shoot parameter specifying target
# and adjust for enemy vs player shooting

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Play noise
	#Start Particles
	#Discover target
	currentTarget = EnemyManager.enemies_in_play[randi_range(0, EnemyManager.total_enemies - 1)]
	startPosition = position
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	MissileBehavior(delta)


func _on_body_entered(body: Node3D) -> void:
	print(body.get_groups())
	if body.is_in_group("Enemies"):
		body.DamageEnemy(damageAmount)
		# Deploy particle effect and sound
		queue_free()

func MissileBehavior(delta):
	timer += delta
	if currentTarget:
		position = lerp(startPosition, currentTarget.position, timer / life_time)
		look_at(currentTarget.position)
	else:
		position += -transform.basis.z * delta
