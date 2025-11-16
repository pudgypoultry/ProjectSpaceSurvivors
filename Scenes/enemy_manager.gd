extends Node3D

# hold enemies, types, etc.
@export var enemy_types:Array[PackedScene] = []
var spawn_range:float = 10
var player_ship: Node3D
var enemies_in_play = []
var total_enemies = 0

# manage timers, spawning, stopping on menus

# function to run through list of enemies and pause them

# function to run through list of enemies and damage them

# function to run through list of enemies and destroy selected types

func GetTargetEnemy():
	return enemies_in_play.pick_random()

func SpawnEnemy(enemy_index:int) -> void:
	# random angle between -PI and +PI
	var phi = 2 * PI * randf() - PI
	var theta = 2 * PI * randf() - PI
	var x = spawn_range * sin(theta) * cos(phi)
	var y = spawn_range * sin(theta) * sin(phi)
	var z = spawn_range * cos(theta)
	# add current position to spawn position
	var spawn_pos:Vector3 = Vector3(x, y, z)
	spawn_pos += player_ship.position
	# spawn enemy
	var newscene:Node3D = self.enemy_types[enemy_index].instantiate()
	self.add_child(newscene)
	enemies_in_play.append(newscene)
	# update location
	newscene.position = spawn_pos
	total_enemies += 1

var tmp:float = 0
func _process(delta: float) -> void:
	if player_ship:
		tmp += delta
		if tmp > 1:
			SpawnEnemy(randi_range(0, 0))
			tmp = 0

func _ready():
	player_ship = get_node("/root/Sandbox/PlayerShip")
