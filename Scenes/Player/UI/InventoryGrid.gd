extends GridContainer

class_name InventoryGrid
@export var rows : int = 7
@export var tileScene : PackedScene
var playerInventory : ShipInventoryController
var currentDrag = null
var currentTile = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Populate the board
	for i in range(rows * columns):
		add_child(tileScene.instantiate())
	# Set up the board
	#	Need to have a way of importing/exporting shapes
	var children = get_children()
	var index = 0
	playerInventory = get_parent().get_parent()
	for tile in children:
		
		tile.inventoryManager = self
		#find up
		if index - columns > 0:
			tile.up = children[index - columns]
		#find down
		if index + columns < len(children):
			tile.down = children[index + columns]
		#find left
		if index % columns != 0 && index - 1 > 0:
			tile.left = children[index - 1]
		#find right
		if (index + 1) % columns != 0 && index + 1 < len(children):
			tile.right = children[index + 1]
		index += 1

# Hey Godot this is wack lol
func _notification(whichNotification: int) -> void:
	if whichNotification == NOTIFICATION_DRAG_END and not get_viewport().gui_is_drag_successful():
		currentTile.texture = currentDrag
