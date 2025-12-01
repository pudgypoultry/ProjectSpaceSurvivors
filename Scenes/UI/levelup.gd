extends Control

# call show_level_up_menu to start whole level and buff
# selection process

var player

@export_category("Weapon Equips")
@export var beamSword : PackedScene
@export var missileSilo : PackedScene
@export var laser : PackedScene
@export var mine : PackedScene

@export_category("Passive Equips")
@export var armoredHull : PackedScene
@export var chassis : PackedScene
@export var fabricator : PackedScene
@export var fusionReactor : PackedScene
@export var inertiaDampener : PackedScene
@export var machineLearning : PackedScene
@export var powerCells : PackedScene
@export var radar : PackedScene
@export var repairBots : PackedScene
@export var targetingSystem : PackedScene
@export var thrusters : PackedScene
@export var tractorBeam : PackedScene
@export var weaponsSystem : PackedScene

var upgrade_options



func _input(event):
	if event.is_action_pressed("level_up"):
		print("level up pressed!")
		show_level_up_menu()

@export var button_container: VBoxContainer

signal upgrade_selected(upgrade_name: String)

func _ready():
	upgrade_options = [
	{"name": "Armored Hull", "description" : "+5% Armor", "object" : armoredHull},
	{"name": "Chassis", "description" : "+20 Max HP", "object" : chassis},
	{"name": "Fabricator", "description" : "+1 Projectiles", "object" : fabricator},
	{"name": "Fusion Reactor", "description" : "+15% Damage", "object" : fusionReactor},
	{"name": "Inertia Dampeners", "description" : "Better momentum control", "object" : inertiaDampener},
	{"name": "Machine Learning", "description" : "More efficient scrap collection", "object" : machineLearning},
	{"name": "Power Cells", "description": "+50% Duration", "object" : powerCells},
	{"name": "Radar", "description": "+50% Area", "object" : radar},
	{"name": "Repair Bots", "description": "Heal 5 hp/s", "object" : repairBots},
	{"name": "Targeting System", "description": "+20% Attack Speed", "object" : targetingSystem},
	{"name": "Thrusters", "description" : "+10% Speed", "object" : thrusters},
	{"name": "Tractor Beam", "description" : "+50% Collection Radius", "object" : thrusters},
	{"name": "Thrusters", "description" : "+10% Ship Speed", "object" : thrusters},
	{"name": "Weapons System", "description": "+50% Projectile speed", "object" : weaponsSystem},
	
	{"name": "Energy Sword", "description": "A rotating beam sword", "is_weapon" : true, "object" : beamSword},
	{"name": "Missile Silos", "description": "Seek and destroy", "is_weapon" : true, "object" : missileSilo}
	# {"name": "Laser Beam", "description": "Y = mX + b", "is_weapon" : true, "object" : laser, "amount": 0}
	]
	for option in upgrade_options:
		option["is_equipped"] = false
		option["reference"] = null
		if "is_weapon" not in option.keys():
			pass
			option["is_weapon"] = false
		
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
	if !upgrade["is_equipped"]:
		button.text = upgrade["name"] + "\n" + upgrade["description"]
	else:
		print("Current level for " + upgrade["name"] + ":	" + str(upgrade["reference"].level))
		button.text = upgrade["name"] + "\n" + upgrade["reference"].levelUpDescriptions[upgrade["reference"].level]
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
		equipment.OnLevelUp(equipment.level)
		if equipment.level == equipment.maxLevel:
			var neededIndex
			for i in range(len(upgrade_options)):
				if upgrade["name"] == upgrade_options[i]["name"]:
					neededIndex = i
			upgrade_options.pop_at(neededIndex)
	
func clear_buttons():
	for child in button_container.get_children():
		child.queue_free()
	
	
	
	
	
	
	
