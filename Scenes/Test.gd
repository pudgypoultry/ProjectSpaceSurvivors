extends Node

@export var missiles : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(5).timeout
	print("Starting Test")
	for i in range(50):
		var new_missile = missiles.instantiate()
		get_parent().add_child(new_missile)
		new_missile.position = Vector3.ZERO


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
