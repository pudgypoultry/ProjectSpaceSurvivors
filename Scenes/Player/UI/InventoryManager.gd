class_name InventoryManager

extends Node

@export_category("Game Rules")
@export var gridRowsMax : int = 5
@export var gridColsMax : int = 5

@export_category("Plugging in Nodes")
@export var playerShip : PlayerController
@export var inventoryScreen : CanvasLayer
@export var playerInventoryGrid : InventoryGrid

var grid : Array[Array] = []
var currentEquipments = []
var menuOpen = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	playerShip = EnemyManager.player_ship


func _input(event):
	if event.is_action_pressed("pause"):
		#print("toilet humor")
		var new_state = not get_tree().paused
		get_tree().paused = new_state
		if !menuOpen:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			ShowInventory()
			menuOpen = true
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			get_tree().paused = false
			menuOpen = false
			HideInventory()
			UpdateShip()


func ShowInventory():
	inventoryScreen.visible = true


func HideInventory():
	inventoryScreen.visible = false


func UpdateShip():
	# Wipe all weapons of player
	for n in playerShip.weaponFolder.get_children():
		playerShip.weaponFolder.remove_child(n)
		n.queue_free()
	print("Weapon Folder Contents:	", str(playerShip.weaponFolder.get_children()))
	currentEquipments = []
	var equipmentAggregation = playerInventoryGrid.gridItems
	# Spawn all new weapons
	for equipment : BackpackItemUI in equipmentAggregation:
		if equipment.equipmentScene != null:
			var currentScene : PlayerEquipment = equipment.equipmentScene.instantiate()
			# If the weapon is already on the player, level it up by unpacking the packed scene
			if currentScene.equipmentName in currentEquipments:
				# Find the weapon in the weapon folder, then level it up
				for item : PlayerEquipment in playerShip.weaponFolder.get_children():
					if item.equipmentName == currentScene.equipmentName:
						item.LevelUp()
						print("		LEVELING UP:	", currentScene.name)
						break
				currentScene.queue_free()
			# Else, instantiate the weapon
			else:
				print("	INSTANTIATING WEAPON:	", currentScene.name)
				playerShip.weaponFolder.add_child(currentScene)
				currentEquipments.append(currentScene.equipmentName)
	print("Current Equipments:	", str(playerShip.weaponFolder.get_children()))
