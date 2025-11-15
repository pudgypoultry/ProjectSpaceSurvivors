extends Node3D
class_name Weapon

@export var fire_rate : float = 1.0
@export var spawn_positions : Array[Vector3] = []
@export var spawn_directions : Array[Vector3] = []
@export var missile_object : PackedScene

func Fire():
	for i in range(len(spawn_positions)):
		var new_missile = missile_object.instantiate()
		new_missile.position = spawn_positions[i]
		new_missile.rotation = spawn_directions[i]
