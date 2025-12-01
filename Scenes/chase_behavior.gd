extends Node

var enemy: EnemyGrunt
var enemy_grunt: EnemyGrunt
var target_coords: Vector3
var collision_margin:float = 0.5

func _ready():
	enemy_grunt = self.get_parent() as EnemyGrunt
	
func move_to(delta):
	# Calculate the vector pointing from the enemy to the target
	var vector_to_target: Vector3 = (target_coords - enemy_grunt.position)
	
	# Check distance squared (standard optimization to avoid square roots)
	# If close enough to "collide" or attack
	if vector_to_target.length_squared() < collision_margin:
		Globalhealthscript.damage_player(enemy_grunt.damage)
		enemy_grunt.DestroyEnemy()
		return

	# Normalize the vector to get a direction of length 1
	var direction: Vector3 = vector_to_target.normalized()

	# Calculate the distance to move this frame (Constant Speed)
	# NOTE: I removed the * 0.01 and + 0.005. You may need to adjust your 
	# enemy_grunt.speed value in the inspector to compensate.
	var move_distance: float = enemy_grunt.speed * delta
	
	# Apply the movement
	enemy_grunt.position += direction * move_distance

	# Rotate to point at the player
	# We use -direction because look_at aligns the -Z axis. 
	# If your model faces +Z, you look at -direction.
	if direction.length_squared() > 0.001: # Prevent rotation errors if vectors are zero
		var target_basis: Basis = Basis.looking_at(-direction)
		enemy_grunt.transform.basis = enemy_grunt.transform.basis.slerp(target_basis, 0.5)
	
func _physics_process(delta):
	target_coords = EnemyManager.player_ship.position
	move_to(delta)
	
