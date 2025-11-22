extends Node

var aggregation : Dictionary = {}
var playerShip : PlayerController

func StartGame(playerObject):
	playerShip = playerObject

func Aggregate():
	for equipment : PlayerEquipment in playerShip.equipped_weapons:
		for stat in equipment.statChanges.keys():
			aggregation[stat] += equipment.statChanges[stat]
	for equipment : PlayerEquipment in playerShip.equipped_passives:
		for stat in equipment.statChanges.keys():
			aggregation[stat] += equipment.statChanges[stat]
