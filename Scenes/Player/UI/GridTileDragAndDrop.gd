extends TextureRect

class_name GridTile

@export var inventoryGrid : InventoryGrid
@export var currentItem : BackpackItemUI
@export var previewColor : Color
@export var testTexture : Texture2D
@export var debug : bool = false

var prepared = false
var index : int = 0
var up : GridTile = null
var down : GridTile = null
var left : GridTile = null
var right : GridTile = null

var lastLeftTexture
var lastRightTexture
var lastUpTexture
var lastDownTexture

@warning_ignore("unused_parameter")
func _get_drag_data(at_position: Vector2) -> Variant:
	var preview_texture = TextureRect.new()
	
	inventoryGrid.currentDrag = currentItem
	inventoryGrid.currentTile = self
	preview_texture.texture = texture
	preview_texture.expand_mode = 1
	preview_texture.size = Vector2(30,30)
	
	inventoryGrid.playerInventory.currentHeldItem = currentItem
	currentItem.lastOwner = inventoryGrid
	currentItem.lastPosition = currentItem.originPoint
	inventoryGrid.failedDragItem = currentItem
	inventoryGrid.failedDragPosition = currentItem.originPoint
	
	var preview = Control.new()
	preview.add_child(preview_texture)
	
	set_drag_preview(preview)
	texture = null
	
	var returnItem = inventoryGrid.PickUpItem(currentItem)
	currentItem = null
	return returnItem


@warning_ignore("unused_parameter")
func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	if data is BackpackItemUI:
		inventoryGrid.ClearTextures()
		var validPlacement = true
		for i in range(len(data.adjacencies)):
			# print("Check " + str(i) + ":")
			if data.IsValidPlacement(self, int(data.adjacencies[i].x), int(data.adjacencies[i].y)) == false:
				validPlacement = false
				break
		print(validPlacement)
		if validPlacement:
			inventoryGrid.PreviewItem(data, index)
			# print("Poopoopoop")
		return validPlacement
	else:
		return false


@warning_ignore("unused_parameter")
func _drop_data(at_position: Vector2, data: Variant) -> void:
	if data is GridTile:
		print("Hey it works you're great hell yeah cool")
	inventoryGrid.PlaceItem(data, index)


func DebugMouseOver():
	if debug:
		texture = testTexture
		if left:
			lastLeftTexture = left.texture
			left.texture = testTexture
		if right:
			lastRightTexture = right.texture
			right.texture = testTexture
		if up:
			lastUpTexture = up.texture
			up.texture = testTexture
		if down:
			lastDownTexture = down.texture
			down.texture = testTexture


func DebugMouseLeave():
	if debug:
		texture = null
		if left:
			left.texture = lastLeftTexture
		if right:
			right.texture = lastRightTexture
		if up:
			up.texture = lastUpTexture
		if down:
			down.texture = lastDownTexture
