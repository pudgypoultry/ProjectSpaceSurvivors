extends Node3D
class_name Weapon

@export var fire_rate : float = 10.00
@export var spawn_positions : Array[Vector3] = []
@export var spawn_directions : Array[Vector3] = []
@export var missile_object : PackedScene
@export var delay_between_fires : float = 0

var timer : float = 0.0
var player = EnemyManager.player_ship

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer += delta
	fire_rate *= (1/player.modify_fire_rate)
	if timer > fire_rate:
		Fire()
		timer = 0.0


func Fire():
	while(true):
		print("Launching missiles")
		for i in range(len(spawn_positions)):
			var new_missile = missile_object.instantiate()
			# print("Spawned " + str(new_missile) + " : " + str(new_missile.global_position))
			new_missile.position = spawn_positions[i] + global_position
			get_tree().root.add_child(new_missile)
			new_missile.siloObject = self
			await get_tree().create_timer(delay_between_fires).timeout
		await get_tree().create_timer(fire_rate).timeout
