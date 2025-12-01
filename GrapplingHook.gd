extends RigidBody3D
class_name GrapplingHook

var playerReference : PlayerController
var moveDirection : Vector3
#@export var path : Path3D
#@export var csgPolygon : CSGPolygon3D
@export var hingeJoint : HingeJoint3D
@export var initialForce : float = 10.0
@export var lineRadius = 0.1
@export var lineResolution = 180

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



func Grapple():
	set_freeze_enabled(true)
	hingeJoint.node_a = self.get_path()
	hingeJoint.node_b = playerReference.get_path()


func Fire(direction : Vector3):
	set_freeze_enabled(false)
	sleeping = false
	apply_central_impulse(direction * initialForce)
	print(linear_velocity)
	print("Applying Force in direct: " + str(direction))

func Release():
	queue_free()

func _on_collision(body: Node3D) -> void:
	if body.is_in_group("Grappleable"):
		print("lol found one")
		Grapple()
