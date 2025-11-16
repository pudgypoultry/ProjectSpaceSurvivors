extends Label



func _process(delta):
	# Access the global score and set the label's text
	text = "Health: " + str(Globalhealthscript.health)
