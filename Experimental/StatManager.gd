extends Node

var aggregation : Dictionary = {}
var playerShip : PlayerController

func Refresh():
	aggregation["damage"] = 1.0
	aggregation["duration"] = 1.0
	aggregation["cooldown"] = 1.0
	aggregation["area"] = 1.0
	aggregation["projectileSpeed"] = 1.0
	aggregation["projectileAmount"] = 1.0


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
