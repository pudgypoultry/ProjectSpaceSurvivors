extends Node

var enemy: Enemy

var target_coords

func _ready():
	target_coords = EnemyManager.player_ship.position
