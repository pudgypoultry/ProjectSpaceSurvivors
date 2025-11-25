extends EquipmentPassive

func _ready():
	super._ready()

func OnLevelUp(currentLevel : int):
	print("leveling up to level: " + str(currentLevel + 1))
	match currentLevel:
		2:
			level += 1
			statChanges["area"] += 0.5
		3:
			level += 1
			statChanges["area"] += 0.5
		4:
			level += 1
			statChanges["area"] += 0.5
		5:
			level += 1
			statChanges["area"] += 0.5
		_:
			pass
