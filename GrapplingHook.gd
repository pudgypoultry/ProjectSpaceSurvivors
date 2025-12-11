extends RigidBody3D
class_name GrapplingHook

var playerReference : PlayerController
var moveDirection : Vector3
#@export var path : Path3D
#@export var csgPolygon : CSGPolygon3D
@export var grappleJoint : Generic6DOFJoint3D
@export var initialForce : float = 10.0
@export var lineRadius = 0.1
@export var lineResolution = 180
@export var stiffness = 10.0
@export var damping = 1.0
@export var restLength = 2.0

var launched = false
var grappled = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	playerReference = EnemyManager.player_ship
	max_contacts_reported = 2
	# path.curve.add_point(playerReference.position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#var circle = PackedVector2Array()
	#for degree in lineResolution:
		#var x = lineRadius * sin(PI*2*degree/lineResolution)
		#var y = lineRadius * cos(PI*2*degree/lineResolution)
		#var coords = Vector2(x,y)
		#circle.append(coords)
	#csgPolygon.polygon = circle
	# path.curve.set_point_position(-1, playerReference.position)

func _physics_process(delta: float) -> void:
	if grappled:
		HandleGrapple(delta)



func Grapple():
	grappled = true
	set_freeze_enabled(true)
	#grappleJoint.set_param_x(grappleJoint.PARAM_LINEAR_UPPER_LIMIT, currentDifference.x)
	#grappleJoint.set_param_y(grappleJoint.PARAM_LINEAR_UPPER_LIMIT, currentDifference.y)
	#grappleJoint.set_param_z(grappleJoint.PARAM_LINEAR_UPPER_LIMIT, currentDifference.z)
	#grappleJoint.node_a = self.get_path()
	#grappleJoint.node_b = playerReference.get_path()

func HandleGrapple(delta):
	var targetDirection = playerReference.global_position.direction_to(self.global_position)
	var targetDistance = playerReference.global_position.distance_to(self.global_position)
	var displacement = targetDistance - restLength
	var force = Vector3.ZERO
	
	if displacement > 0:
		var springForceMagnitude = stiffness * (displacement*displacement)
		var springForce = targetDirection * springForceMagnitude
		
		var velDot = playerReference.velocity.dot(targetDirection)
		var damping = -damping * velDot * targetDirection
		
		force = springForce + damping
	
	playerReference.apply_central_force(force * delta)

func Fire(direction : Vector3):
	set_freeze_enabled(false)
	sleeping = false
	apply_central_impulse(direction * initialForce)
	# print(linear_velocity)
	# print("Applying Force in direct: " + str(direction))

func Release():
	queue_free()

func _on_collision(body: Node3D) -> void:
	if body.is_in_group("Grappleable"):
		print("lol found one")
		Grapple()
