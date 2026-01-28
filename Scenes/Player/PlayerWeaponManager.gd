extends Node3D

class_name WeaponManager

var weaponsDict : Dictionary = {}

func AddWeapon(weapon : BackpackItemUI):
	# This needs to take a given BackpackItemUI, unpack the packed scene within it, and apply it to the player's ship correctly
	weapon.UnpackItem(get_parent(), self)
