extends Control
@export var mainscene = "res://sandbox.tscn"




func _on_resume_pressed() -> void:
	
	$click.play()


func _on_quit_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.

	
	


func _on_quit_mouse_entered() -> void:
	$hover.play()


func _on_resume_mouse_entered() -> void:
	$hover.play()
