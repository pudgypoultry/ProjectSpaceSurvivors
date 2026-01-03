extends Node

var aggregation : Dictionary = {}
var playerShip : PlayerController

func Refresh():
	# Fusion Reactor
	aggregation["damage"] = 1.0
	# Power Cells
	aggregation["duration"] = 1.0
	# Targeting System
	aggregation["cooldown"] = 1.0
	# Radar
	aggregation["area"] = 1.0
	# Weapons Systems
	aggregation["projectileSpeed"] = 1.0
	# Fabricator
	aggregation["projectileAmount"] = 1.0
	
	# Chassis
	aggregation["health"] = 1.0
	# Armored Hull
	aggregation["armor"] = 1.0
	# Thrusters
	aggregation["speed"] = 1.0
	# Machine Learning
	aggregation["experience"] = 1.0
	# Repair Bots
	aggregation["repair"] = 1.0
	# Inertia Dampeners
	aggregation["inertia"] = 1.0
	# Tractor Beam
	aggregation["pickupRange"] = 1.0


func StartGame(playerObject):
	playerShip = playerObject
	Refresh()


func Aggregate():
	Refresh()
	for equipment : PlayerEquipment in playerShip.equipped_weapons:
		for stat in equipment.statChanges.keys():
			aggregation[stat] += equipment.statChanges[stat]
	for equipment : PlayerEquipment in playerShip.equipped_passives:
		for stat in equipment.statChanges.keys():
			aggregation[stat] += equipment.statChanges[stat]
