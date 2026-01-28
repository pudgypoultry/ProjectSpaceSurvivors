extends Node

class_name BackpackItemUI

@export var equipmentScene : PackedScene
@export var equipmentID : int
@export var adjacencies : Array[Vector2] = [Vector2(0,0)]
@export var imageSections : Array[Texture2D] = []
@export var isWeapon : bool = true
var lastOwner : InventoryGrid
var lastPosition : int
var originPoint : int

# All adjacencies should be of the form Vector2(x, y)
#	So all checked values will be Vector2(index + x, index + (y*columns))
#	We are assuming that adjacencies start at Vector2(0,0) relative to an original point
func IsValidPlacement(node, newX, newY):
	var validX = true
	var validY = true
	
	var currentNode = node
	for i in range(abs(newX)):
		if newX < 0:
			currentNode = currentNode.left
		if newX > 0:
			currentNode = currentNode.right
		if currentNode == null:
			#print("Found blank on X check " + str(i))
			validX = false
			break
		elif currentNode.currentItem != null:
			#print("Found item on X check " + str(i))
			validX = false
			break
	#print("	ValidX: " + str(validX))
	currentNode = node
	for i in range(abs(newY)):
		if newY > 0:
			currentNode = currentNode.down
		if newY < 0:
			currentNode = currentNode.up
		if currentNode == null:
			#print("Found blank on Y check " + str(i))
			validY = false
			break
		elif currentNode.currentItem != null:
			#print("Found item on Y check " + str(i))
			validY = false
			break
	
	#print("	ValidY: " + str(validY))
	if validX and validY:
		return true
	else:
		return false


func FindAdjacentItems(nodes : Array[GridTile]):
	var returnList = {}
	for node in nodes:
		if node.up != null:
			if node.up.currentItem != null and node.up.currentItem != self:
				returnList[node.up.currentItem] = 1
		if node.left != null:
			if node.left.currentItem != null and node.left.currentItem != self:
				returnList[node.left.currentItem] = 1
		if node.down != null:
			if node.down.currentItem != null and node.down.currentItem != self:
				returnList[node.down.currentItem] = 1
		if node.right != null:
			if node.right.currentItem != null and node.right.currentItem != self:
				returnList[node.right.currentItem] = 1
	return returnList.keys()


# Each backpack item should overwrite this function in order to tell the player ship how to unpack this
func UnpackItem(player : PlayerController, weaponManager : WeaponManager):
	print("Hey I'm here")
