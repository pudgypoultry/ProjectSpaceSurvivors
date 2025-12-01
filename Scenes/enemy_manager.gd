extends Node3D

# hold enemies, types, etc.
@export var enemy_types:Array[PackedScene] = []
var spawn_range:float = 15
var player_ship: Node3D
var enemies_in_play = []
var total_enemies = 0
var enemygrunt2 = preload("res://Scenes/Enemies/enemy_grunt2.tscn")
var spawnTimer:float = 0.0
var spawnInterval:float = 1.0
var maxEnemies : int = 200
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


func _process(delta: float) -> void:
	if player_ship:
		spawnTimer += delta
		if spawnTimer > spawnInterval && len(enemies_in_play) < maxEnemies:
			SpawnEnemy(randi_range(0, 0))
			SpawnEnemy(randi_range(0, 0))
			spawnTimer = 0
			spawnInterval *= 0.999

func _ready():
	if get_tree().get_current_scene().get_name() == "Sandbox":
		player_ship = get_node("/root/Sandbox/PlayerShip")
		get_node("/root/Sandbox/Levelup").player = player_ship
	enemy_types.append(enemygrunt2)
	ResetEnemies()

func ResetEnemies():
	for i in range(total_enemies):
		enemies_in_play.pop_front().queue_free()
	total_enemies = 0
