extends EquipmentWeapon

@export_category("Beam Sword Options")
@export var swordRotations : Array[float]

var swords : Array[Node3D] = []

func _ready():
	var firstSword = projectileObject.instantiate()
	add_child(firstSword)
	swords.append(firstSword)
	super._ready()


func _process(delta : float):
	pass


func OnLevelUp(currentLevel : int):
	print("leveling " + name + " up to level: " + str(currentLevel + 1))
	match currentLevel + 1:
		2:
			level += 1
			var secondSword = projectileObject.instantiate()
			secondSword.rotation.z = 0.125 * 2 * PI - PI
			add_child(secondSword)
			swords.append(secondSword)
		3:
			level += 1
			var thirdSword = projectileObject.instantiate()
			thirdSword.rotation.z = 0.875 * 2 * PI - PI
			add_child(thirdSword)
			swords.append(thirdSword)
			# secondSword.rotation.z = 0.25 * 2 * PI - PI
		4:
			level += 1
			for sword in swords:
				sword.frequency *= 1.5
		5:
			level += 1
			for sword in swords:
				sword.frequency *= 1.5
		6:
			level += 1
			for sword in swords:
				sword.frequency *= 1.25
		7:
			level += 1
			for sword in swords:
				sword.frequency *= 1.25
		8:
			level += 1
			baseDamage += 0.25
			baseProjectileSpeed += 0.25
		_:
			pass
	
	print("Current baseDamage: " + str(baseDamage))
	RecalculateStats()
