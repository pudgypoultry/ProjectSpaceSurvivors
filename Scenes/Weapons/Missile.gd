extends Node
class_name Missile

@export_category("Game Rules")
@export var movement_speed : float = 1.0
@export var damage : float = 10.0
@export var acceleration : float = 0.0
@export var life_time : float = 10.0
# @export var sound_effect : Audio
# @export var particle_effect : GPUParticles3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Play noise
	#Start Particles
	#Discover target
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node3D) -> void:
	if body.is_class("Enemy"):
		body.take_damage(damage)
		# Deploy particle effect and sound
		queue_free()
