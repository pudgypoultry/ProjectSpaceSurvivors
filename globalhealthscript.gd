extends Node
var health: int= 100
signal game_over()

func damage_player(damage:float) -> void:
	health -= damage
	if health < 0:
		# player dead
		get_tree().paused= true
		game_over.emit()
