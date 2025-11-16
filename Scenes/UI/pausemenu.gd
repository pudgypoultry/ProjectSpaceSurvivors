extends Control


func _input(event):
	if event.is_action_pressed("pause"):
		toggle_pause_menu()

func toggle_pause_menu():
	var new_state= not get_tree().paused
	get_tree().paused = new_state
	visible = new_state
	 
