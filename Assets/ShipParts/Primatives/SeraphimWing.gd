extends Node3D

@export var wingLayers : Array[Node3D] = []
@export var interval : float = 0.5
var timer = 0.0
var rotations = []
var lastRotations = []
# Called when the node enters the scene tree for the first time.

func _ready():
	for layer in wingLayers:
		rotations.append(layer.global_rotation.x)
		lastRotations.append(layer.global_rotation.x)
	print("ORIGINALSTATE")
	print(rotations)
	print(lastRotations)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer += delta
	if timer > interval:
		timer = 0.0
		var i = 0
		for layer in wingLayers:
			lastRotations[i] = rotations[i]
			rotations[i] = layer.global_rotation.x
			for child : MeshInstance3D in layer.get_children():
				var mat : ShaderMaterial = child.get_active_material(0)
				mat.set_shader_parameter("rotation_amount", mat.get_shader_parameter("rotation_amount") + rotations[i])
			rotations[i] -= lastRotations[i]
			i += 1
		print("-=-=-=-=-=-=-=-=-=-=-")
		print(rotations)
		print("===========")
		print(lastRotations)
		print("-=-=-=-=-=-=-=-=-=-=-")
