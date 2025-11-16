extends Control

# call show_level_up_menu to start whole level and buff
# selection process

var upgrade_options = [
	{"name": "Increased Max Health", "description": "+20 Max HP", "stat": "playerhealth", "value": "20"},
	{"name": "Faster Movement", "description": "+10% Speed"},
	{"name": "Extra Damage", "description": "+15% Damage"},
	{"name": "Attack Speed", "description": "+20% Attack Speed"},
]

func _input(event):
	if event.is_action_pressed("level_up"):
		print("level up pressed!")
		show_level_up_menu()

@export var button_container: VBoxContainer

signal upgrade_selected(upgrade_name: String)

func _ready():
	# hide by default
	hide()

func show_level_up_menu():
	clear_buttons()
	get_tree().paused = true
	generate_random_options(3)
	show()

func generate_random_options(n: int):
	var available = upgrade_options.duplicate()
	available.shuffle()
	for i in range(min(n, available.size())):
		create_upgrade_button(available[i])
	
func create_upgrade_button(upgrade: Dictionary):
	var button = Button.new()
	button.text = upgrade["name"] + "\n" + upgrade["description"]
	button.custom_minimum_size = Vector2(800, 200)
	
	# normal style
	var button_style = StyleBoxFlat.new()
	button_style.bg_color = Color(0.695, 0.209, 0.682, 1.0)  # Blue-ish
	button_style.set_border_width_all(2)
	button_style.border_color = Color(0.612, 0.85, 0.874, 1.0)
	button.add_theme_stylebox_override("normal", button_style)

	# hover style
	var hover_style = StyleBoxFlat.new()
	hover_style.bg_color = Color(0.8, 0.3, 0.8, 1.0)  # Lighter purple on hover
	hover_style.set_border_width_all(2)
	hover_style.border_color = Color(1.0, 1.0, 0.0, 1.0)  # Yellow border
	button.add_theme_stylebox_override("hover", hover_style)

	button.pressed.connect(_on_upgrade_selected.bind(upgrade["name"]))
	button_container.add_child(button)

func _on_upgrade_selected(upgrade_name: String):
	print("Selected upgrade: ", upgrade_name)
	upgrade_selected.emit(upgrade_name)
	hide()
	get_tree().paused = false
	
func clear_buttons():
	for child in button_container.get_children():
		child.queue_free()
	
	
	
	
	
	
	
