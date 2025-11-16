extends Label



func _process(delta):
	# Access the global score and set the label's text
	text = "Level: " + str(Globallevelscript.level)
