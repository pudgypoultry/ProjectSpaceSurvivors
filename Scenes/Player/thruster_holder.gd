extends Node3D

var thrust : float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	thrust = clampf(thrust, 0.0, 1.0)
	scale = Vector3(thrust, thrust, thrust)
