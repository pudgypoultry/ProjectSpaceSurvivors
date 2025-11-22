extends Control

# call show_level_up_menu to start whole level and buff
# selection process

var player

@export var beamSword : PackedScene
@export var missileSilo : PackedScene
@export var laser : PackedScene
@export var mine : PackedScene

var upgrade_options



func _input(event):
	if event.is_action_pressed("level_up"):
		print("level up pressed!")
		show_level_up_menu()

@export var button_container: VBoxContainer

signal upgrade_selected(upgrade_name: String)

func _ready():
	upgrade_options = [
	{"name": "Increased Max Health", "description": "+20 Max HP", "stat": "Globalhealthscript.health", "value": 20, "is_weapon" : false},
	{"name": "Faster Movement", "description": "+10% Speed", "stat": "max_speed", "value": 0.10, "is_percent": true, "is_weapon" : false},
	{"name": "Extra Damage", "description": "+15% Damage", "stat": "modify_damage", "value": 0.15, "is_percent": true, "is_weapon" : false},
	{"name": "Attack Speed", "description": "+20% Attack Speed", "stat": "modify_fire_rate", "value": 0.20, "is_percent": true, "is_weapon" : false},
	{"name": "Energy Sword", "description": "A rotating beam sword", "is_weapon" : true, "object" : beamSword, "amount": 0},
	{"name": "Missile Silos", "description": "Seek and destroy", "is_weapon" : true, "object" : missileSilo, "amount": 0}
	# {"name": "Laser Beam", "description": "Y = mX + b", "is_weapon" : true, "object" : laser, "amount": 0}
	]
	for option in upgrade_options:
		option["is_equipped"] = false
		option["reference"] = null
	player = EnemyManager.player_ship
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
	if not player:
		print("Error: Not player")
		return
	
	#print("DEBUG: Player node found: ", player)
	#print("DEBUG: Player script: ", player.get_script())
	
	# Try to list all properties
	#print("DEBUG: Player has these properties:")
	for prop in player.get_property_list():
		if prop.usage & PROPERTY_USAGE_SCRIPT_VARIABLE:
			print("  - ", prop.name, " = ", player.get(prop.name))
	
	if !upgrade["is_equipped"]:
		print(upgrade["object"])
		var newWeapon = upgrade["object"].instantiate()
		upgrade["reference"] = newWeapon
		print("NEW REFERENCE:")
		print(upgrade["reference"])
		player.EquipWeapon(newWeapon)
		upgrade["is_equipped"] = true
	# Item is equipped
	else:
		print("hello hi how are you hello")
		var equipment = upgrade["reference"]
		equipment.OnLevelUp(equipment.level + 1)
	
func clear_buttons():
	for child in button_container.get_children():
		child.queue_free()
	
	
	
	
	
	
	
