extends Node3D
class_name Weapon

@export var fire_rate : float = 1.0
@export var spawn_positions : Array[Vector3] = []
@export var spawn_directions : Array[Vector3] = []
@export var missile_object : PackedScene
@export var delay_between_fires : float = 0

var timer : float = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer += delta
	if timer > fire_rate:
		Fire()
		timer = 0.0


func Fire():
	for i in range(len(spawn_positions)):
		var new_missile = missile_object.instantiate()
		new_missile.position = spawn_positions[i]
		new_missile.rotation = spawn_directions[i]
		await get_tree().create_timer(delay_between_fires).timeout
