extends Control
@export var mainscene = "res://sandbox2.tscn"





func _ready():
	
	get_tree().paused= true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	


func _on_button_pressed() ->  void:
	
	# get_tree().paused= false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().change_scene_to_file("res://Scenes/sandbox2.tscn")
	self.visible= false
	$click.play()
	
	



func _on_quitbutton_pressed() -> void:
	get_tree().quit()
	pass 


func _on_startbutton_mouse_entered() -> void:
	$hover.play()
	
	
	
