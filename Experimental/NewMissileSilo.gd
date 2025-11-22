extends EquipmentWeapon

@export_category("Missile Silo Options")
@export var firePositions : Array[Node3D]

var missileCounter = 0

# Instantiate a missile from the correct silo, prepare for next instantiation
func Fire():
	var new_missile = projectileObject.instantiate()
	new_missile.position = firePositions[missileCounter].global_position
	new_missile.rotation = playerReference.rotation
	missileCounter += 1
	missileCounter %= len(firePositions)
	get_tree().root.add_child(new_missile)
	new_missile.siloObject = self
	await get_tree().create_timer(currentCooldown).timeout

func OnLevelUp(currentLevel : int):
	print("leveling up on level: " + str(currentLevel))
	match currentLevel:
		1:
			level += 1
			baseDamage += 0.25
			baseProjectileSpeed += 0.25
		2:
			level += 1
			baseDamage += 0.25
			baseProjectileSpeed += 0.25
		3:
			level += 1
			baseDamage += 0.25
			baseProjectileSpeed += 0.25
		4:
			level += 1
			baseDamage += 0.25
			baseProjectileSpeed += 0.25
		5:
			level += 1
			baseDamage += 0.25
			baseProjectileSpeed += 0.25
		6:
			level += 1
			baseDamage += 0.25
			baseProjectileSpeed += 0.25
		7:
			level += 1
			baseDamage += 0.25
			baseProjectileSpeed += 0.25
		8:
			level += 1
			baseDamage += 0.25
			baseProjectileSpeed += 0.25
	
	print("Current baseDamage: " + str(baseDamage))
	RecalculateStats()
