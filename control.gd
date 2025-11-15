extends Control
@export var mainscene = "res://sandbox.tscn"




func _on_button_pressed() -> void:
	self.visible= false
	pass # Replace with function body.
	



func _on_quitbutton_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.
