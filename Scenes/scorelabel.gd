extends Label



func _process(delta):
	# Access the global score and set the label's text
	text = "EXP: " + str(Globalpointscript.score)
