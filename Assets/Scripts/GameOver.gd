extends Control
@export var mainscene = "res://sandbox2.tscn"





func _ready():
	
	get_tree().paused= true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	


func _on_button_pressed() ->  void:
	
	# get_tree().paused= false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	self.visible= false
	get_tree().change_scene_to_file.call_deferred("res://Scenes/sandbox2.tscn")
	var s = EnemyManager.get_script()
	EnemyManager.set_script(null)
	EnemyManager.set_script(s)
	$click.play()
	

func _on_quitbutton_pressed() -> void:
	get_tree().quit()
	pass 


func _on_startbutton_mouse_entered() -> void:
	$hover.play()
	
	
	
