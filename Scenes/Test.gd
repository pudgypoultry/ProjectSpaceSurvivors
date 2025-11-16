extends Node

@export var missiles : PackedScene
@export var player : Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	TestMissiles()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func TestMissiles():
	while(true):
		await get_tree().create_timer(3).timeout
		print("Starting Test")
		for i in range(5):
			var new_missile = missiles.instantiate()
			get_parent().add_child(new_missile)
			new_missile.position = player.position
