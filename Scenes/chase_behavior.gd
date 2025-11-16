extends Node

var enemy: EnemyGrunt
var enemy_grunt: EnemyGrunt
var target_coords: Vector3
var collision_margin:float = 1

func _ready():
	enemy_grunt = self.get_parent() as EnemyGrunt
	
func move_to(delta):
	var direction:Vector3 = (target_coords - enemy_grunt.position)
	if direction.dot(direction) < collision_margin:
		Globalhealthscript.damage_player(enemy_grunt.damage)
		enemy_grunt.DestroyEnemy()
		return
	direction = direction.normalized()
	var distance:float = delta * enemy_grunt.speed * 0.1
	var move_vec:Vector3 = direction * distance
	enemy_grunt.position += move_vec
	# rotate to point at the player
	var target_basis:Basis = Basis.looking_at(-direction)
	enemy_grunt.transform.basis = enemy_grunt.transform.basis.slerp(target_basis, 0.5)
	
func _physics_process(delta):
	target_coords = EnemyManager.player_ship.position
	move_to(delta)
	
