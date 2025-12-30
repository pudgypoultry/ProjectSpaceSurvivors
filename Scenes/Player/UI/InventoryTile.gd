class_name InventoryTile

extends Node

var isValid = false
var isOccupied = false
var currentItemID = -1
var currentPartID = -1
var currentItemNode : PlayerEquipment = null
var leftTile : InventoryTile = null
var rightTile : InventoryTile = null
var upTile : InventoryTile = null
var downTile : InventoryTile = null
