extends Node



enum Direction {UP, DOWN, LEFT, RIGHT}

@export_category("Game Rules")
@export var xMax : float = 2.5
@export var yMax : float = 2.0
@export var verticalMoveSpeed : float = 2.0
@export var horizontalMoveSpeed : float = 2.5
@export var verticalRotationAmount : float = 10.0
@export var horizontalRotationAmount : float = 5.0
@export var targetSpeed : float = 1

@export_category("Plugging In Nodes")
@export var shipTarget : Node3D

var actorReference : PlayerController
var displacement : Vector2 = Vector2(0.0, 0.0)
var xMaxTarget : float
var yMaxTarget : float
var originalBasis : Basis

func _ready():
	actorReference = get_parent().get_parent()
	actorReference.thrusterHolder.thrust = 1.0
	originalBasis = actorReference.basis
	xMaxTarget = xMax * 1.25
	yMaxTarget = yMax * 1.25


func Process(delta: float) -> void:
	#print(EnemyManager.enemies_in_play)
	
	var up_down = Input.get_axis("throttle_down", "throttle_up")
	var left_right = Input.get_axis("roll_left", "roll_right")
	
	# Going Up
	if up_down > 0:
		if IsInBounds(Direction.UP):
			displacement.y += verticalMoveSpeed * delta
			actorReference.position += originalBasis.y * verticalMoveSpeed * delta
			shipTarget.position.y += 1.25 * verticalMoveSpeed * targetSpeed * delta
	
	# Going Down
	if up_down < 0:
		if IsInBounds(Direction.DOWN):
			displacement.y += -verticalMoveSpeed * delta
			actorReference.position += originalBasis.y * -verticalMoveSpeed * delta
			shipTarget.position.y += 1.5 * -verticalMoveSpeed * targetSpeed * delta
	
	# Going Right
	if left_right > 0:
		if IsInBounds(Direction.RIGHT):
			displacement.x += horizontalMoveSpeed * delta
			actorReference.position += originalBasis.x * horizontalMoveSpeed * delta
			if actorReference.rotation.z > deg_to_rad(-40):
				actorReference.basis = actorReference.basis.get_rotation_quaternion().slerp(actorReference.basis.rotated(actorReference.basis.z, deg_to_rad(-50)).orthonormalized(), delta)
			shipTarget.position.x += horizontalMoveSpeed * targetSpeed * delta
	
	# Going Left
	if left_right < 0:
		if IsInBounds(Direction.LEFT):
			displacement.x += -horizontalMoveSpeed * delta
			actorReference.position += originalBasis.x * -horizontalMoveSpeed * delta
			if actorReference.rotation.z < deg_to_rad(40):
				actorReference.basis = actorReference.basis.get_rotation_quaternion().slerp(actorReference.basis.rotated(actorReference.basis.z, deg_to_rad(50)).orthonormalized(), delta)
			print(actorReference.rotation.z)
			shipTarget.position.x += -horizontalMoveSpeed * targetSpeed * delta

	if up_down == 0:
		shipTarget.position.y = lerp(shipTarget.position.y, actorReference.position.y, 3 * delta)
	if left_right == 0:
		shipTarget.position.x = lerp(shipTarget.position.x, actorReference.position.x, 3 * delta)
		actorReference.basis = actorReference.basis.get_rotation_quaternion().slerp(originalBasis.orthonormalized(), 5 * delta)


func IsInBounds(direction : Direction):
	match direction:
		Direction.UP:
			if displacement.y < 0:
				return true
			if abs(displacement.y) <= yMax:
				return true
			else:
				return false
		Direction.DOWN:
			if displacement.y > 0:
				return true
			if abs(displacement.y) <= yMax:
				return true
			else:
				return false
		Direction.LEFT:
			if displacement.x > 0:
				return true
			if abs(displacement.x) <= xMax:
				return true
			else:
				return false
		Direction.RIGHT:
			if displacement.x < 0:
				return true
			if abs(displacement.x) <= xMax:
				return true
			else:
				return false

@warning_ignore("unused_parameter")
func PhysicsProcess(delta: float) -> void:
	actorReference.look_at(shipTarget.global_position, actorReference.global_basis.y)


func OrientCharacterToDirection(direction : Vector3, delta : float):
	if direction.length_squared() > 0:
		var backAxis : Vector3 = actorReference.basis.z
		var rightAxis := -backAxis.cross(direction)
		
		var rotationBasis := Basis(rightAxis, direction, backAxis).orthonormalized()
		actorReference.basis = actorReference.basis.get_rotation_quaternion().slerp(rotationBasis, delta)
