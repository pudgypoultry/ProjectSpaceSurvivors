extends Control
@export var mainscene = "res://sandbox.tscn"


func _input(event):
	if event.is_action_pressed("pause"):
		toggle_pause_menu()
		

func toggle_pause_menu():
	var new_state= not get_tree().paused
	print(visible)
	if visible:
		self.hide()
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else:
		self.show()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = new_state


func _on_resume_pressed() -> void:
	get_tree().paused= false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	self.visible= false
	
	


func _on_quit_pressed() -> void:
	get_tree().quit()
	pass 
	



func _on_quit_mouse_entered() -> void:
	$hover.play()
