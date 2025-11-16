extends Node3D

@onready var raycast = $laserbeam

func _process(delta):
	if raycast:
		fire_laser()
	# await get_tree.createtimer(seconds).timeout
	# use above function to do pauses

func fire_laser():
	raycast.force_raycast_update()  # Update immediately
	
	if raycast.is_colliding():
		var hit_object = raycast.get_collider()
		var hit_point = raycast.get_collision_point()	
		hit_object.get_parent().damaged.emit(10)
