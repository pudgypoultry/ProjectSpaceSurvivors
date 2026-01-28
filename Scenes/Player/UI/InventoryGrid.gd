extends GridContainer

class_name InventoryGrid

@export var rows : int = 7
@export var tileScene : PackedScene
@export var itemStartPosition : int
@export var startingItem : BackpackItemUI
@export var hasStartingItem : bool
@export var previewTexture : Texture2D
var originalTexture : Texture2D

var playerInventory : ShipInventoryController
var currentDrag = null
var currentTile = null
var failedDragItem : BackpackItemUI = null
var failedDragPosition : int = 0
var gridTiles : Array[GridTile] = []
var gridItems : Array[BackpackItemUI] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Populate the board
	while len(get_children()) < (rows * columns):
		add_child(tileScene.instantiate())
	var children = get_children()
	for i in range(len(children)):
		gridTiles.append(children[i])
		children[i].index = i
	
	originalTexture = gridTiles[0].texture
	
	for tile in gridTiles:
		if tile.currentItem and !tile.prepared:
			tile.currentItem.lastOwner = self
			tile.currentItem.lastPosition = tile.index
			PlaceItem(tile.currentItem, tile.index)
			for pos in tile.currentItem.adjacencies:
				var currentPosition = int(tile.index + pos.x + columns * pos.y)
				gridTiles[currentPosition].prepared = true
	
	for tile in gridTiles:
		tile.prepared = false
	
	# Set up the board
	#	Need to have a way of importing/exporting shapes

	var index = 0
	playerInventory = get_parent().get_parent()
	for tile in gridTiles:
		tile.inventoryGrid = self
		#find up
		if index - columns > 0:
			tile.up = children[index - columns]
		#find down
		if index + columns < len(children):
			tile.down = children[index + columns]
		#find left
		if index % columns != 0 && index - 1 >= 0:
			tile.left = children[index - 1]
		#find right
		if (index + 1) % columns != 0 && index + 1 < len(children):
			tile.right = children[index + 1]
		index += 1
	
	if hasStartingItem:
		PlaceItem(startingItem, itemStartPosition)


func PreviewItem(item : BackpackItemUI, placePosition : int):
	ClearTextures()
	for i in range(len(item.adjacencies)):
		var currentPosition = int(placePosition + item.adjacencies[i].x + columns * item.adjacencies[i].y)
		gridTiles[currentPosition].texture = previewTexture


func PlaceItem(item : BackpackItemUI, placePosition : int):
	ClearTextures()
	item.originPoint = placePosition
	for i in range(len(item.adjacencies)):
		var currentPosition = int(placePosition + item.adjacencies[i].x + columns * item.adjacencies[i].y)
		gridTiles[currentPosition].texture = item.imageSections[i]
		gridTiles[currentPosition].currentItem = item
	gridItems.append(item)
	print(gridItems)


func PickUpItem(item : BackpackItemUI):
	ClearTextures()
	for pos in item.adjacencies:
		var currentPosition = item.originPoint + pos.x + columns * pos.y
		print("	Attempting to pick up from: " + str(currentPosition))
		gridTiles[currentPosition].texture = null
		gridTiles[currentPosition].currentItem = null
	gridItems.erase(item)
	return item


func ClearTextures():
	for tile in gridTiles:
		if tile.currentItem == null:
			tile.texture = originalTexture


func AggregateEquipment():
	var aggregation = {}
	for tile in gridTiles:
		if tile.currentItem != null:
			print("===")
			print(tile.currentItem)
			print("===")
			if tile.currentItem not in aggregation.keys():
				aggregation[tile.currentItem] = 1
			else:
				aggregation[tile.currentItem] += 1
	return aggregation


func AggregateAdjacencies():
	var aggregation = {}
	for tile in gridTiles:
		if tile.currentItem != null:
			if tile.currentItem not in aggregation.keys():
				aggregation[tile.currentItem] = tile.currentItem.FindAdjacentItems(gridTiles)
	return aggregation
