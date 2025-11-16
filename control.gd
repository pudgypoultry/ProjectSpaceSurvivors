extends Control
@export var mainscene = "res://sandbox.tscn"







func _on_button_pressed() ->  void:
	
	
	self.visible= false
	$click.play()
	
	



func _on_quitbutton_pressed() -> void:
	get_tree().quit()
	pass 


func _on_startbutton_mouse_entered() -> void:
	$hover.play()
	
	
	
