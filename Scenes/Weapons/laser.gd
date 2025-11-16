extends Node3D

@onready var raycast = $laserbeam
var laser_firing = false
@onready var laser: Node3D = $"."
@onready var laser_mesh: CSGCylinder3D = $CSGCylinder3D
var laser_firing_duration:float = 0.5

func _ready() -> void:
	laser_mesh.hide()

func _process(delta):
	if raycast:
		fire_laser()
	# await get_tree.createtimer(seconds).timeout
	# use above function to do pauses
	
func damage_target() -> void:
	var hit_object = raycast.get_collider()
	#var hit_point = raycast.get_collision_point()	
	hit_object.DamageEnemy(10)

func fire_laser():
	raycast.force_raycast_update()  # Update immediately
	
	if raycast.is_colliding() and not laser_firing:
		laser_firing = true
		laser_mesh.show()
		damage_target()
		await get_tree().create_timer(laser_firing_duration).timeout
		laser_firing = false
		laser_mesh.hide()
	elif raycast.is_colliding():
		damage_target()
