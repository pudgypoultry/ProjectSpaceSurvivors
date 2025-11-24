extends EquipmentWeapon

@export_category("Missile Silo Options")
@export var firePositions : Array[Node3D]

var missileCounter = 0
var doubleFire = false

# Instantiate a missile from the correct silo, prepare for next instantiation
func Fire():
	if !doubleFire:
		var new_missile = projectileObject.instantiate()
		#new_missile.global_position = firePositions[missileCounter].global_position
		new_missile.rotation = playerReference.rotation
		missileCounter += 1
		missileCounter %= len(firePositions)
		new_missile.position = firePositions[missileCounter].global_position
		get_tree().root.add_child(new_missile)
		new_missile.siloObject = self
		new_missile.movement_speed = currentProjectileSpeed
		await get_tree().create_timer(currentCooldown).timeout
	else:
		var new_missile1 = projectileObject.instantiate()
		var new_missile2 = projectileObject.instantiate()
		print("Missile counter + 2: " + str((missileCounter + 2) % len(firePositions)))
		missileCounter += 1
		missileCounter %= len(firePositions)
		new_missile1.position = firePositions[missileCounter].global_position
		new_missile1.rotation = playerReference.rotation
		new_missile2.position = firePositions[(missileCounter + 2) % len(firePositions)].global_position
		new_missile2.rotation = playerReference.rotation
		get_tree().root.add_child(new_missile1)
		get_tree().root.add_child(new_missile2)
		new_missile1.siloObject = self
		new_missile1.movement_speed = currentProjectileSpeed
		new_missile2.siloObject = self
		new_missile2.movement_speed = currentProjectileSpeed
		await get_tree().create_timer(currentCooldown).timeout

func OnLevelUp(currentLevel : int):
	print("leveling " + name + " up to level: " + str(currentLevel + 1))
	match currentLevel + 1:
		2:
			level += 1
			doubleFire = true
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
		_:
			pass
	
	print("Current baseDamage: " + str(baseDamage))
	RecalculateStats()
