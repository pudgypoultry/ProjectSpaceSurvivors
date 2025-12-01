extends Label

var neededExp : float = 100.0

func level_up():
	var levelup = $"../../Levelup"
	Globallevelscript.level += 1
	levelup.show_level_up_menu()

func _process(delta):
	# Access the global score and set the label's text
	text = "Level: " + str(Globallevelscript.level)
	if Globallevelscript.level * neededExp <= Globalpointscript.score:
		level_up()
		neededExp *= 1.75
