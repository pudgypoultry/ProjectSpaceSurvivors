extends PlayerEquipment

class_name EquipmentPassive

@export var baseDamage : float = 1.0
@export var baseDuration : float = 1.0
@export var baseCooldown : float = 1.0
@export var baseArea : float = 1.0
@export var baseProjectileSpeed : float = 1.0
@export var baseProjectileAmount : int = 1

var currentDamage
var currentDuration
var currentCooldown
var currentArea
var currentProjectileSpeed
var currentProjectileAmount

func _ready():
	RecalculateStats()
	super._ready()


func RecalculateStats():
	currentDamage = baseDamage
	currentDuration = baseDuration
	currentCooldown = baseCooldown
	currentArea = baseArea
	currentProjectileSpeed = baseProjectileSpeed
	currentProjectileAmount = baseProjectileAmount
