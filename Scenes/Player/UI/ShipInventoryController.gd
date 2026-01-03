extends Panel

class_name ShipInventoryController

var currentHeldItem : BackpackItemUI
var playerReference : PlayerController
@export var shipInventory : InventoryGrid
func _ready():
	playerReference = EnemyManager.player_ship

func PutItemBack():
	currentHeldItem.lastOwner.PlaceItem(currentHeldItem, currentHeldItem.lastPosition)

# Hey Godot this is wack lol
func _notification(whichNotification: int) -> void:
	if whichNotification == NOTIFICATION_DRAG_END and not get_viewport().gui_is_drag_successful():
		PutItemBack()
