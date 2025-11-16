extends Control

# call show_level_up_menu to start whole level and buff
# selection process

var upgrade_options = [
	{"name": "Increased Max Health", "description": "+20 Max HP", "stat": "Globalhealthscript.health", "value": 20},
	{"name": "Faster Movement", "description": "+10% Speed", "stat": "max_speed", "value": 0.10, "is_percent": true},
	{"name": "Extra Damage", "description": "+15% Damage", "stat": "modify_damage", "value": 0.15, "is_percent": true},
	#{"name": "Attack Speed", "description": "+20% Attack Speed", "stat": "modify_fire_rate", "value": 0.20, "is_percent": true},
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
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
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
	
	# Find the upgrade data
	var upgrade_data = null
	for upgrade in upgrade_options:
		if upgrade["name"] == upgrade_name:
			upgrade_data = upgrade
			break
	
	if upgrade_data:
		apply_upgrade(upgrade_data)
	
	upgrade_selected.emit(upgrade_name)
	hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().paused = false

func apply_upgrade(upgrade: Dictionary):
	var player = get_node("/root/Sandbox/PlayerShip")
	if not player:
		print("Error: Not player")
		return
	
	print("DEBUG: Player node found: ", player)
	print("DEBUG: Player script: ", player.get_script())
	
	# Try to list all properties
	print("DEBUG: Player has these properties:")
	for prop in player.get_property_list():
		if prop.usage & PROPERTY_USAGE_SCRIPT_VARIABLE:
			print("  - ", prop.name, " = ", player.get(prop.name))
	
	var stat = upgrade["stat"]
	var value = upgrade["value"]
	var is_percent = upgrade.get("is_percent", false)
	
	print("Trying to modify stat: ", stat)
	print("Current value: ", player.get(stat))
	print("New value to add: ", value)
	
	if stat == "Globalhealthscript.health":
		if is_percent:
			Globalhealthscript.health = Globalhealthscript.health * (1 + value)
		else:
			Globalhealthscript.health += value
		print("Applied ", upgrade["name"], " - new health: ", Globalhealthscript.health)
		return
	
	if is_percent:
		var current_val = player.get(stat)
		print("DEBUG: current_val type: ", typeof(current_val))
		print("DEBUG: current_val value: ", current_val)
		if current_val == null:
			print("ERROR: Value is null!")
			return
		# Multiply current stat by percentage
		player.set(stat, current_val * (1 + value))
	else:
		# Add flat value
		player.set(stat, player.get(stat) + value)
	
	print("Applied ", upgrade["name"], " to player")
	
func clear_buttons():
	for child in button_container.get_children():
		child.queue_free()
	
	
	
	
	
	
	
