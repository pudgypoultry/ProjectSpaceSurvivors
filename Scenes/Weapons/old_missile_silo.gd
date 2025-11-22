extends Weapon

func _ready():
	spawn_positions = [Vector3(0.5, 0, 0), 
	Vector3(-0.5, 0, 0),
	Vector3(0.5, 0, 0.2),
	Vector3(-0.5, 0, 0.2),
	Vector3(0.5, 0, 0.4),
	Vector3(-0.5, 0, 0.4),
	Vector3(0.5, 0, 0.6),
	Vector3(-0.5, 0, 0.6)
	]
	delay_between_fires = 2.0
	Fire()
