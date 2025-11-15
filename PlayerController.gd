extends Node3D

@export var throttle : float = 1.0
@export var throttle_min : float = 0.0
@export var throttle_max : float = 10.0
@export var direction : Vector3
@export var playerHealth : float = 100.0
@export var rotationSpeed : float = 0.1

var canAct : bool = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	direction = -transform.basis.z


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var up_down = Input.get_axis("nose_up", "nose_down")
	var left_right = Input.get_axis("roll_left", "roll_right")
	var throttle_change = Input.get_axis("throttle_down", "throttle_up")
	
	if up_down != Vector2.ZERO:
		rotation += transform.basis.y * up_down * delta
	if left_right != Vector2.ZERO:
		rotation += transform.basis.x * left_right * delta
	if throttle_change != Vector2.ZERO:
		throttle += throttle_change * delta
		clampf(throttle, throttle_min, throttle_max)
