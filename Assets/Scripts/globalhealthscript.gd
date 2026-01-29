extends Node
var health: int= 100


func damage_player(damage:float) -> void:
	health -= damage
	if health <= 0:
		# player dead
		
		get_tree().paused= false
		get_tree().change_scene_to_file.call_deferred("res://Scenes/UI/gameover.tscn")
		
