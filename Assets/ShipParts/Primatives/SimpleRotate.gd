extends Node3D

@export var rotationSpeed : float = 3.0
var clockwise = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if randf() > 0.5:
		clockwise = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if clockwise:
		rotate_object_local(transform.basis.y, deg_to_rad(rotationSpeed * randf())/5)
	else:
		rotate_object_local(transform.basis.y, -deg_to_rad(rotationSpeed * randf())/5)
