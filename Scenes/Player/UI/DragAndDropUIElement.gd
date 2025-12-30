extends TextureRect

class_name GridTile

@export var inventoryManager : InventoryGrid

var currentItem

var up : GridTile = null
var down : GridTile = null
var left : GridTile = null
var right : GridTile = null

@warning_ignore("unused_parameter")
func _get_drag_data(at_position: Vector2) -> Variant:
	var preview_texture = TextureRect.new()
	
	inventoryManager.currentDrag = texture
	inventoryManager.currentTile = self
	preview_texture.texture = texture
	preview_texture.expand_mode = 1
	preview_texture.size = Vector2(30,30)
	
	var preview = Control.new()
	preview.add_child(preview_texture)
	
	set_drag_preview(preview)
	texture = null
	
	if up:
		up.texture = null
	if left:
		left.texture = null
	if right:
		right.texture = null
	if down:
		down.texture = null
	
	return preview_texture.texture


@warning_ignore("unused_parameter")
func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data is Texture2D


@warning_ignore("unused_parameter")
func _drop_data(at_position: Vector2, data: Variant) -> void:
	if data is GridTile:
		print("Hey it works you're great hell yeah cool")
	texture = data
	if up:
		up.texture = data
	if left:
		left.texture = data
	if right:
		right.texture = data
	if down:
		down.texture = data
