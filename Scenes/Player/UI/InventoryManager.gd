class_name InventoryManager

extends Node

@export_category("Game Rules")
@export var gridRowsMax : int = 5
@export var gridColsMax : int = 5

@export_category("Plugging in Nodes")
@export var inventoryScreen : CanvasLayer
@export var playerInventoryGrid : InventoryGrid

var grid : Array[Array] = []
var currentEquipments = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(gridRowsMax):
		var currentRow = []
		for j in range(gridColsMax):
			currentRow.append(InventoryTile.new())
		grid.append(currentRow)
	
	print(grid)


func EquipItem(listOfPositions, itemID, itemNode):
	var valid = ValidatePosition(listOfPositions)
	if !valid:
		return false
	for pos in listOfPositions:
		grid[pos[0]][pos[1]].currentItemID = itemID
		grid[pos[0]][pos[1]].currentItemNode = itemNode
	AggregateEquipment()


func ValidatePosition(listOfPositions):
	for pos in listOfPositions:
		var currentPos = grid[pos[0]][pos[1]]
		if currentPos.isOccupied or !currentPos.isValid:
			return false
	return true


func AggregateEquipment():
	var aggregation = {}
	for row in grid:
		for tile in row:
			if tile.isOccupied:
				aggregation[tile.itemNode] = tile.itemNode.name
	currentEquipments = aggregation.keys()
	return currentEquipments


func ShowInventory():
	inventoryScreen.visible = true


func HideInventory():
	inventoryScreen.visible = false


func UpdateShip():
	var equipmentAggregation = playerInventoryGrid.AggregateEquipment()
	var equipmentAdjacencies = playerInventoryGrid.AggregateAdjacencies()
