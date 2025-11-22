extends PlayerEquipment

class_name EquipmentWeapon

@export_category("Weapon Qualities")
@export var baseDamage : float = 1.0
@export var baseDuration : float = 1.0
@export var baseCooldown : float = 1.0
@export var baseArea : float = 1.0
@export var baseProjectileSpeed : float = 1.0
@export var baseProjectileAmount : int = 1
@export var projectileObject : PackedScene
@export var weaponSound : AudioStreamPlayer3D

var currentDamage
var currentDuration
var currentCooldown
var currentArea
var currentProjectileSpeed
var currentProjectileAmount

var timer = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	RecalculateStats()
	super._ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer += delta
	if timer > currentCooldown:
		Fire()
		timer = 0.0


func Fire():
	print("	Fire for " + name + " is not implemented yet")
	pass


func RecalculateStats():
	currentDamage = baseDamage
	currentDuration = baseDuration
	currentCooldown = baseCooldown
	currentArea = baseArea
	currentProjectileSpeed = baseProjectileSpeed
	currentProjectileAmount = baseProjectileAmount
