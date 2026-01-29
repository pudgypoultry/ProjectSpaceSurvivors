extends EquipmentWeapon

@export_category("Beam Sword Options")
@export var swordRotations : Array[float]

var swords : Array[Node3D] = []

func _ready():
	var firstSword = projectileObject.instantiate()
	add_child(firstSword)
	swords.append(firstSword)
	super._ready()


func _process(_delta : float):
	pass


func LevelUp():
	print("leveling " + name + " up to level: " + str(level + 1))
	
	match level + 1:
		2:
			level += 1
			var secondSword : Node3D = projectileObject.instantiate()
			var tiltBasis = global_basis.rotated(Vector3.FORWARD, deg_to_rad(45))
			
			add_child(secondSword)
			swords.append(secondSword)
			secondSword.global_basis *= tiltBasis
			print("Made 2nd sword")
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
