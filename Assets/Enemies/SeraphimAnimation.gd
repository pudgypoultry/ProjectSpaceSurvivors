extends Node3D

@export var topRightWing : Node3D
@export var topLeftWing : Node3D
@export var midRightWing : Node3D
@export var midLeftWing : Node3D
@export var bottomRightWing : Node3D
@export var bottomLeftWing : Node3D

var wings
var tweens : Array[Tween] = []
var originalPositions : Array[Vector3]
@export var openPositions : Array[Vector3]
@export var timeToOpen : float = 3.0
@export var timeToClose : float = 3.0
var waveMovement = 0.0
var open = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	wings = [topRightWing, topLeftWing, midRightWing, midLeftWing, bottomRightWing, bottomLeftWing]
	for wing in wings:
		originalPositions.append(wing.rotation)
		tweens.append(create_tween().bind_node(wing))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	waveMovement += delta
	position.z += sin(waveMovement)
	if Input.is_key_pressed(KEY_SPACE) && !open:
		SpreadWings()
		open = true
	elif Input.is_key_pressed(KEY_SPACE) && open:
		AtRest()
		open = false
	


func SpreadWings():
	var i = 0
	for wing in wings:
		TweenTools.TweenRotation(wing, tweens[i], openPositions[i], timeToOpen)
		i += 1

func AtRest():
	var i = 0
	for wing in wings:
		TweenTools.TweenRotation(wing, tweens[i], originalPositions[i], timeToClose)
		i += 1
