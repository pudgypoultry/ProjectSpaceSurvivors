extends Node3D

class_name PlayerEquipment

@export_category("Base Equipment Properties")
@export var equipmentName : String
@export var equipmentDescription : String
@export var icon : Texture2D
@export var level : int = 1
@export var maxLevel : int = 10
@export var levelUpDescriptions : Array[String] = []

@export_category("Plugging in Nodes")
@export var mesh : MeshInstance3D
@export var statChanges : Dictionary = {}

var playerReference : PlayerController

func _ready():
	playerReference = EnemyManager.player_ship

func LevelUp():
	# print("OnLevelUp for " + name + " is not implemented yet")
	match level:
		_:
			print("OnLevelUp for " + name + " is not implemented yet")

func RecalculateStats():
	pass
