extends Node3D

@onready var raycast = $laserbeam
var laser_firing = false
@onready var laser: Node3D = $"."
@onready var laser_mesh: CSGCylinder3D = $CSGCylinder3D
var laser_firing_duration:float = 0.5
var damage = 10

func _ready() -> void:
	laser_mesh.hide()

func _process(delta):
	if raycast:
		fire_laser()
	# await get_tree.createtimer(seconds).timeout
	# use above function to do pauses

func fire_laser():
	raycast.force_raycast_update()  # Update immediately
	
	if raycast.is_colliding() and not laser_firing:
		var hit_object = raycast.get_collider()
		if hit_object.is_in_group("Enemies"):
			laser_firing = true
			laser_mesh.show()
			var player = EnemyManager.player_ship
			var newDamage = player.modify_damage * damage
			hit_object.DamageEnemy(newDamage)
			await get_tree().create_timer(laser_firing_duration).timeout
			laser_firing = false
			laser_mesh.hide()
	elif raycast.is_colliding():
		var hit_object = raycast.get_collider()
		if hit_object.is_in_group("Enemies"):
			hit_object.DamageEnemy(10)
